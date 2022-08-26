
locals {
  tmp_dir = "${path.cwd}/.tmp/git-repo"
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

data external ca_cert {
  program = ["bash", "${path.module}/scripts/initialize-ca-cert.sh"]

  query = {
    bin_dir = module.setup_clis.bin_dir
    ca_cert = var.ca_cert
    ca_cert_file = var.ca_cert_file
    tmp_dir = local.tmp_dir
  }
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
    GIT_PROJECT = var.project
    TMP_DIR = local.tmp_dir
    DEBUG = var.debug
    CA_CERT = data.external.ca_cert.result.ca_cert_file
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-repo.sh '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${var.public}' '${self.triggers.MODULE_ID}' '${var.strict}'"

    environment = {
      GIT_PROJECT = self.triggers.GIT_PROJECT
      GIT_USERNAME = self.triggers.USERNAME
      GIT_TOKEN = nonsensitive(self.triggers.TOKEN)
      GIT_CA_CERT = self.triggers.CA_CERT
      BIN_DIR = self.triggers.BIN_DIR
      TMP_DIR = self.triggers.TMP_DIR
      DEBUG = self.triggers.DEBUG
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-repo.sh '${self.triggers.HOST}' '${self.triggers.ORG}' '${self.triggers.REPO}' '${self.triggers.MODULE_ID}'"

    environment = {
      GIT_PROJECT = self.triggers.GIT_PROJECT
      GIT_USERNAME = self.triggers.USERNAME
      GIT_TOKEN = nonsensitive(self.triggers.TOKEN)
      GIT_CA_CERT = self.triggers.CA_CERT
      BIN_DIR = self.triggers.BIN_DIR
      TMP_DIR = self.triggers.TMP_DIR
      DEBUG = self.triggers.DEBUG
    }
  }
}

data external repo_info {
  depends_on = [null_resource.repo]

  program = ["bash", "${path.module}/scripts/get-repo-url.sh"]

  query = {
    bin_dir = module.setup_clis.bin_dir
    host = var.host
    org = local.org
    repo = var.repo
    project = var.project
    username = var.username
    token = var.token
  }
}
