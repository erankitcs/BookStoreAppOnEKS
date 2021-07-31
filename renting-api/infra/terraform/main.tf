provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "dynamodb_table" {
  source   = "../../../tf_modules/dynamodb"
  namespace = "development"
  api_name  = "RentingApi"
  table_name = "renting"
  hash_key = "_id"
  attributes = [
    {
      name = "_id"
      type = "S"
    }
  ]
}

module "prod_dynamodb_table" {
  source   = "../../../tf_modules/dynamodb"
  namespace = "prod"
  api_name  = "RentingApi"
  table_name = "renting"
  hash_key = "_id"
  attributes = [
    {
      name = "_id"
      type = "S"
    }
  ]
}

output "ddb_policy_arn" {
  description = "ARN of the DynamoDb Policy for RentingApi."
  value       = module.dynamodb_table.ddb_policy_arn
}

output "ddb_table_arn" {
  description = "ARN of the DynamoDb Table for RentingApi."
  value       = module.dynamodb_table.ddb_table_arn
}

output "prod_ddb_policy_arn" {
  description = "ARN of the DynamoDb Policy for RentingApi for Prod Env."
  value       = module.prod_dynamodb_table.ddb_policy_arn
}

output "prod_ddb_table_arn" {
  description = "ARN of the DynamoDb Table for RentingApi Prod Env."
  value       = module.prod_dynamodb_table.ddb_table_arn
}