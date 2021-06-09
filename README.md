# Git repo module

Module to provision a git repository

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v13
- gh - GitHub cli (provided)
- glab - Gitlab cli (provided)

### Terraform providers

## Module dependencies

None

## Example usage

```hcl-terraform
module "git-repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-git-repo.git"
  
  host = "github.com"
  type = "github"
  org  = var.git_org
  repo = var.git_repo
  token = var.git_token
}
```

### Git Token

The git token is used to create, initialize, and delete the repository. It needs to be given enough permission to perform each of those actions.
