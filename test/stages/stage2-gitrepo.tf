module "gitrepo" {
  source = "./module"

  host = "github.com"
  type = "github"
  org  = var.git_org
  repo = var.git_repo
  token = var.git_token
}
