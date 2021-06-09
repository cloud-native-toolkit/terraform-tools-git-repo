module "gitrepo" {
  source = "./module"

  host = "github.com"
  type = "github"
  org  = "seansund"
  repo = "git-module-test"
  token = var.git_token
}
