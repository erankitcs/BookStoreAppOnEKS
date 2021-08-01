locals {
  environments = ["development", "prod"]
  clients_dbpolicies = [data.terraform_remote_state.clients-api.outputs.development_ddb_policy_arn , data.terraform_remote_state.clients-api.outputs.prod_ddb_policy_arn]
  inventory_dbpolicies = [data.terraform_remote_state.inventory-api.outputs.development_ddb_policy_arn , data.terraform_remote_state.inventory-api.outputs.prod_ddb_policy_arn]
  renting_dbpolicies = [data.terraform_remote_state.renting-api.outputs.development_ddb_policy_arn , data.terraform_remote_state.renting-api.outputs.prod_ddb_policy_arn]
  resource_dbpolicies = [data.terraform_remote_state.resource-api.outputs.development_ddb_policy_arn , data.terraform_remote_state.resource-api.outputs.prod_ddb_policy_arn]
}

module "iam_assumable_role_clients_api" {
  count                         = 2  
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-clients-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 2
  role_policy_arns              = [local.clients_dbpolicies[count.index],"arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:bookstore-clients-api-service-account"]
}

module "iam_assumable_role_inventory_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-inventory-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 2
  role_policy_arns              = [local.inventory_dbpolicies[count.index],"arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:bookstore-inventory-api-service-account"]
}

module "iam_assumable_role_renting_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-renting-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 2
  role_policy_arns              = [local.renting_dbpolicies[count.index],"arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:bookstore-renting-api-service-account"]
}

module "iam_assumable_role_resource_api" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-resource-api-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 2
  role_policy_arns              = [local.resource_dbpolicies[count.index],"arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:bookstore-resource-api-service-account"]
}

module "iam_assumable_role_app_mesh" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-sa-app-mesh-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns    = 3
  role_policy_arns              = ["arn:aws:iam::aws:policy/AWSCloudMapFullAccess","arn:aws:iam::aws:policy/AWSAppMeshFullAccess","arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:appmesh-system:bookstore-app-mesh-service-account"]
}

module "iam_assumable_role_front_end" {
  count                         = 2
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.2.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-${local.environments[count.index]}-sa-front-end-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  number_of_role_policy_arns                = 1
  role_policy_arns              = ["arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.environments[count.index]}:bookstore-front-end-service-account"]
}