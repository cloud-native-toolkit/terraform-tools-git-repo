output "repo" {
  description = "The git repo"
  value       = "${var.host}/${var.org}/${var.repo}"
  depends_on  = [null_resource.initialize_repo]
}

output "url" {
  description = "The git repo url"
  value       = "https://${var.host}/${var.org}/${var.repo}"
  depends_on  = [null_resource.initialize_repo]
}

output "branch" {
  description = "The git repo branch"
  value       = local.branch
  depends_on  = [null_resource.initialize_repo]
}

output "token" {
  description = "The token used to authenticate to the gitops repo"
  value       = var.token
  depends_on  = [null_resource.initialize_repo]
  sensitive   = true
}
