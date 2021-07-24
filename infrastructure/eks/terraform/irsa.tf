locals {
  environments = ["development", "prod"]
}

module "iam_assumable_role_clients_api" {
  count                         = 2  
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-clients-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 1
  role_policy_arns              = [data.terraform_remote_state.clients-api.outputs.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:clients-api-iam-service-account"]
}

module "iam_assumable_role_inventory_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-inventory-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 1
  role_policy_arns              = [data.terraform_remote_state.inventory-api.outputs.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:inventory-api-iam-service-account"]
}

module "iam_assumable_role_renting_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-renting-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 1
  role_policy_arns              = [data.terraform_remote_state.renting-api.outputs.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:renting-api-iam-service-account"]
}

module "iam_assumable_role_resource_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-resource-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 1
  role_policy_arns              = [data.terraform_remote_state.resource-api.outputs.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:resource-api-iam-service-account"]
}