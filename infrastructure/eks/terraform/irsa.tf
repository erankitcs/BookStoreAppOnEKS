module "iam_assumable_role_clients_api" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-sa-clients-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  ddb_policy_arn                = 1
  role_policy_arns              = [data.aws_iam_terraform_remote_state.clients-api.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.environment}:clients-api-iam-service-account"]
}

module "iam_assumable_role_inventory_api" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-sa-inventory-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  ddb_policy_arn                = 1
  role_policy_arns              = [data.aws_iam_terraform_remote_state.inventory-api.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.environment}:inventory-api-iam-service-account"]
}

module "iam_assumable_role_renting_api" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-sa-renting-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  ddb_policy_arn                = 1
  role_policy_arns              = [data.aws_iam_terraform_remote_state.renting-api.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.environment}:renting-api-iam-service-account"]
}

module "iam_assumable_role_resource_api" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-sa-resource-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  ddb_policy_arn                = 1
  role_policy_arns              = [data.aws_iam_terraform_remote_state.resource-api.ddb_policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.environment}:resource-api-iam-service-account"]
}