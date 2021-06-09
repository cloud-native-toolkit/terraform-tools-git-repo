
resource null_resource create_repo {
  count = var.provision ? 1 : 0

  triggers = {
    TYPE  = var.type
    HOST  = var.host
    ORG   = var.org
    REPO  = var.repo
    TOKEN = var.token
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${var.public}'"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-repo.sh '${self.triggers.TYPE}' '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}'"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }
}
