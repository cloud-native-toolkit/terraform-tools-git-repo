output "host" {
  description = "The git host"
  value       = var.host
  depends_on  = [null_resource.repo]
}

output "org" {
  description = "The git org"
  value       = local.org
  depends_on  = [null_resource.repo]
}

output "name" {
  description = "The git repo"
  value       = var.repo
  depends_on  = [null_resource.repo]
}

output "repo" {
  description = "The git repo"
  value       = "${var.host}/${local.org}/${var.repo}"
  depends_on  = [null_resource.repo]
}

output "url" {
  description = "The git repo url"
  value       = "https://${var.host}/${var.org}/${var.repo}"
  depends_on  = [null_resource.repo]
}

output "branch" {
  description = "The git repo branch"
  value       = local.branch
  depends_on  = [null_resource.repo]
}

output "username" {
  description = "The username used to authenticate to the gitops repo"
  value       = var.username
  depends_on  = [null_resource.repo]
}

output "token" {
  description = "The token used to authenticate to the gitops repo"
  value       = var.token
  depends_on  = [null_resource.repo]
  sensitive   = true
}
