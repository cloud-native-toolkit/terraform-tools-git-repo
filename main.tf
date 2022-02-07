
locals {
  branch = var.branch != null && var.branch != "" ? var.branch : "main"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["gh", "glab"]
}

resource null_resource create_repo {
  count = var.provision ? 1 : 0

  triggers = {
    TYPE  = var.type
    HOST  = var.host
    ORG   = var.org
    REPO  = var.repo
    TOKEN = var.token
    BIN_DIR = module.setup_clis.bin_dir
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${var.public}'"

    environment = {
      TOKEN = self.triggers.TOKEN
      BIN_DIR = self.triggers.BIN_DIR
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}'"

    environment = {
      TOKEN = self.triggers.TOKEN
      BIN_DIR = self.triggers.BIN_DIR
    }
  }
}

resource null_resource initialize_repo {
  count      = var.provision ? 1 : 0
  depends_on = [null_resource.create_repo]

  provisioner "local-exec" {
    command = "${path.module}/scripts/initialize-repo.sh '${var.host}' '${var.org}' '${var.repo}' '${local.branch}'"

    environment = {
      TOKEN = var.token
    }
  }
}
