provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

module "dynamodb_table" {
  source   = "../../../tf_modules/dynamodb"
  namespace = "development"
  api_name  = "InventoryApi"
  table_name = "inventory"
  hash_key = "_id"
  attributes = [
    {
      name = "_id"
      type = "S"
    }
  ]
}

output "ddb_policy_arn" {
  description = "ARN of the DynamoDb Policy for InventoryApi."
  value       = module.dynamodb_table.ddb_policy_arn
}

output "ddb_table_arn" {
  description = "ARN of the DynamoDb Table for InventoryApi."
  value       = module.dynamodb_table.ddb_table_arn
}