output "resource_api_repository_url" {
  description = "Repository URL of Resource API."
  value       = aws_codecommit_repository.resource_api_codecommit.clone_url_http
}