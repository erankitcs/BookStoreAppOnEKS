output "repository_url" {
  description = "Repository URL"
  value       = aws_codecommit_repository.codecommit.clone_url_http
}

output "ecr_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.ecr.repository_url
}
