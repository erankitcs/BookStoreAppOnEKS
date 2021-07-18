resource "aws_codecommit_repository" "resource_api_codecommit" {
  repository_name = "bookstore-resource-api"
  description     = "This is the BookStore App Resource API Repository"
}