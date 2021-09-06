provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

data "terraform_remote_state" "eks_cluster" {
  backend = "local"
  config = {
    path = "../../eks/terraform/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}

module "cicd_resource_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "resource-api"
  cluster_name= data.terraform_remote_state.eks_cluster.outputs.cluster_name
  service_account_dev_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-development-sa-resource-api-role"
  service_account_prod_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-prod-sa-resource-api-role"
}

module "cicd_renting_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "renting-api"
  cluster_name= data.terraform_remote_state.eks_cluster.outputs.cluster_name
  service_account_dev_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-development-sa-renting-api-role"
  service_account_prod_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-prod-sa-renting-api-role"
}

module "cicd_inventory_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "inventory-api"
  cluster_name= data.terraform_remote_state.eks_cluster.outputs.cluster_name
  service_account_dev_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-development-sa-inventory-api-role"
  service_account_prod_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-prod-sa-inventory-api-role"
}

module "cicd_clients_api" {
  source   = "../../../tf_modules/cicd"
  app_name = "clients-api"
  cluster_name= data.terraform_remote_state.eks_cluster.outputs.cluster_name
  service_account_dev_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-development-sa-clients-api-role"
  service_account_prod_role_arn= "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${data.terraform_remote_state.eks_cluster.outputs.cluster_name}-prod-sa-clients-api-role"
}

module "cicd_front_end" {
  source   = "../../../tf_modules/cicd"
  app_name = "front-end"
  cluster_name= data.terraform_remote_state.eks_cluster.outputs.cluster_name
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

output "cicd_front_end_repository_url" {
  description = "URL of Code Commit Repository for Front End."
  value       = module.cicd_front_end.repository_url
}

output "cicd_front_end_ecr" {
  description = "URL of the ECR for Front End."
  value       = module.cicd_front_end.ecr_url
}