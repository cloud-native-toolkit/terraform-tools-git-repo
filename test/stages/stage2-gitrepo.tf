module "gitrepo" {
  source = "./module"

  host = var.git_host
  org  = var.git_org
  repo = var.git_repo
  username = var.git_username
  token = var.git_token
  project = var.git_project
  strict = true
  ca_cert_file = var.ca_cert_file
}

resource local_file git_output {
  content = jsonencode({
    host = module.gitrepo.host
    org = module.gitrepo.org
    repo = module.gitrepo.repo
    project = module.gitrepo.project
    name = module.gitrepo.name
    url = module.gitrepo.url
    branch = module.gitrepo.branch
    username = module.gitrepo.username
    token = module.gitrepo.token
  })

  filename = ".git_output"
}
