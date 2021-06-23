output "repo" {
  description = "The gitops repo"
  value       = "https://${var.host}/${var.org}/${var.repo}"
  depends_on  = [null_resource.initialize_repo]
}

output "token" {
  description = "The token used to authenticate to the gitops repo"
  value       = var.token
  depends_on  = [null_resource.initialize_repo]
  sensitive   = true
}
