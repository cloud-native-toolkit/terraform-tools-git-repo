
locals {
  branch = var.branch != null && var.branch != "" ? var.branch : "main"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["gh", "glab"]
}

resource random_id module_uuid {
  byte_length = 12
}

data external check_status {
  program = ["bash", "${path.module}/scripts/check-repo.sh"]

  query = {
    bin_dir   = module.setup_clis.bin_dir
    type      = var.type
    host      = var.host
    org       = var.org
    repo      = var.repo
    token     = var.token
    public    = var.public
    branch    = var.branch
    module_id = random_id.module_uuid.id
    strict    = var.strict
  }
}

resource null_resource create_repo {
  count = data.external.check_status.result.provision ? 1 : 0

  triggers = {
    TYPE  = var.type
    HOST  = var.host
    ORG   = var.org
    REPO  = var.repo
    TOKEN = var.token
    BIN_DIR = module.setup_clis.bin_dir
    MODULE_ID = random_id.module_uuid.id
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${var.public}' '${var.branch}' '${self.triggers.MODULE_ID}' '${var.strict}'"

    environment = {
      TOKEN = nonsensitive(self.triggers.TOKEN)
      BIN_DIR = self.triggers.BIN_DIR
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${self.triggers.MODULE_ID}'"

    environment = {
      TOKEN = nonsensitive(self.triggers.TOKEN)
      BIN_DIR = self.triggers.BIN_DIR
    }
  }
}
