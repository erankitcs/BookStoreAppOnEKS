provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "cicd_resource_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "resource-api"
}

module "cicd_renting_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "renting-api"
}

module "cicd_inventory_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "inventory-api"
}

module "cicd_clients_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "clients-api"
}

module "cicd_front_end" {
  source   = "../../../tf_modules/cicd"
  app_name = "front-end"
}


output "cicd_resource_api_repository_url" {
  description = "URL of Code Commit Repository for Resource API."
  value       = module.cicd_resource_api.repository_url
}

output "cicd_resource_api_ecr" {
  description = "URL of the ECR for Resource API."
  value       = module.cicd_resource_api.ecr_url
}

output "cicd_renting_api_repository_url" {
  description = "URL of Code Commit Repository for Renting API."
  value       = module.cicd_renting_api.repository_url
}

output "cicd_renting_api_ecr" {
  description = "URL of the ECR for Renting API."
  value       = module.cicd_renting_api.ecr_url
}

output "cicd_inventory_api_repository_url" {
  description = "URL of Code Commit Repository for Inventory API."
  value       = module.cicd_inventory_api.repository_url
}

output "cicd_inventory_api_ecr" {
  description = "URL of the ECR for Inventory API."
  value       = module.cicd_inventory_api.ecr_url
}

output "cicd_clients_api_repository_url" {
  description = "URL of Code Commit Repository for Clients API."
  value       = module.cicd_clients_api.repository_url
}

output "cicd_clients_api_ecr" {
  description = "URL of the ECR for Clients API."
  value       = module.cicd_clients_api.ecr_url
}

output "cicd_cicd_front_end_repository_url" {
  description = "URL of Code Commit Repository for Front End."
  value       = module.cicd_front_end.repository_url
}

output "cicd_front_end_ecr" {
  description = "URL of the ECR for Front End."
  value       = module.cicd_front_end.ecr_url
}