terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

##### IAM Policy
resource "aws_iam_policy" "ddb_policy" {
  name        = "${var.namespace}-ClientsApiPolicy"
  description = "DynamoDB Policy for ClientsApi."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:PutItem",
        "dynamodb:DescribeTable",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource": [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.namespace}-clients",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${data.aws_caller_identity.current.account_id}/index/*"
      ]
    }
  ]
}
EOF
}

## Clients API DynamoDb Table.
resource "aws_dynamodb_table" "ddb_table" {
  name           = "${var.namespace}-clients"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "_id"
  attribute {
    name = "_id"
    type = "S"
  }
  tags = {
    Name        = "${var.namespace}-clients"
    Namespace = var.namespace
  }
}
