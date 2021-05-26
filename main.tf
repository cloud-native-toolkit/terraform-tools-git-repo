
resource null_resource create_gitlab_repo {
  count = var.provision && var.type == "gitlab" ? 1 : 0

  triggers = {
    TOKEN = var.token
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-gitlab-repo.sh ${var.host} ${var.org} ${var.repo}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-gitlab-repo.sh ${var.host} ${var.org} ${var.repo}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }
}

resource null_resource create_github_repo {
  count = var.provision && var.type == "github" ? 1 : 0

  triggers = {
    TOKEN = var.token
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-github-repo.sh ${var.host} ${var.org} ${var.repo}"

    environment = {
      TOKEN = var.token
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-github-repo.sh ${var.host} ${var.org} ${var.repo}"

    environment = {
      TOKEN = self.triggers.TOKEN
    }
  }
}
