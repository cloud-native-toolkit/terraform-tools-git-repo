
resource null_resource create_gitlab_repo {
  count = var.provision && var.type == "gitlab" ? 1 : 0

  triggers = {
    HOST  = var.host
    ORG   = var.org
    REPO  = var.repo
    TOKEN = var.token
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-gitlab-repo.sh ${self.triggers.HOST} ${self.triggers.ORG} ${self.triggers.REPO} ${var.public}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-gitlab-repo.sh ${self.triggers.HOST} ${self.triggers.ORG} ${self.triggers.REPO}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }
}

resource null_resource create_github_repo {
  count = var.provision && var.type == "github" ? 1 : 0

  triggers = {
    HOST  = var.host
    ORG   = var.org
    REPO  = var.repo
    TOKEN = var.token
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-github-repo.sh ${self.triggers.HOST} ${self.triggers.ORG} ${self.triggers.REPO} ${var.public}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-github-repo.sh ${self.triggers.HOST} ${self.triggers.ORG} ${self.triggers.REPO}}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }
}
