output "ddb_policy_arn" {
  description = "ARN of the DynamoDb Policy"
  value       = aws_iam_policy.ddb_policy.arn
}

output "ddb_table_arn" {
  description = "ARN of the DynamoDb Table"
  value       = aws_dynamodb_table.ddb_table.arn
}