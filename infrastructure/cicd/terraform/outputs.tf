output "repository_url" {
  description = "Repository URL of ${var.app_name}."
  value       = aws_codecommit_repository.codecommit.clone_url_http
}

output "ecr_url" {
  description = "ECR Repository URL of ${var.app_name}."
  value       = aws_ecr_repository.ecr.repository_url
}
