output "ddb_clients_policy_arn" {
  description = "ARN of the DynamoDb Policy for Clients API."
  value       = aws_iam_policy.ddb_policy.arn
}

output "ddb_clients_table_arn" {
  description = "ARN of the DynamoDb Table for Clients API."
  value       = aws_dynamodb_table.ddb_table.arn
}