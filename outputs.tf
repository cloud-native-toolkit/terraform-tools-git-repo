output "repo" {
  description = "The gitops repo"
  value       = "${var.host}/${var.org}/${var.repo}"
  depends_on  = [null_resource.create_github_repo, null_resource.create_gitlab_repo]
}
