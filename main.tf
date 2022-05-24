
locals {
  org = var.org != null && var.org != "" ? var.org : var.username
  branch = "main" // TODO should be looked up using an external data
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["jq", "gitu"]
}

resource random_id module_uuid {
  byte_length = 12
}

resource null_resource repo {
  triggers = {
    HOST  = var.host
    ORG   = local.org
    REPO  = var.repo
    USERNAME = var.username
    TOKEN = var.token
    BIN_DIR = module.setup_clis.bin_dir
    MODULE_ID = random_id.module_uuid.id
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-repo.sh '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${var.public}' '${self.triggers.MODULE_ID}' '${var.strict}'"

    environment = {
      GIT_USERNAME = self.triggers.USERNAME
      GIT_TOKEN = nonsensitive(self.triggers.TOKEN)
      BIN_DIR = self.triggers.BIN_DIR
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-repo.sh '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${self.triggers.MODULE_ID}'"

    environment = {
      GIT_USERNAME = self.triggers.USERNAME
      GIT_TOKEN = nonsensitive(self.triggers.TOKEN)
      BIN_DIR = self.triggers.BIN_DIR
    }
  }
}

