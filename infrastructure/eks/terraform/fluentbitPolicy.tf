resource "aws_iam_policy" "fbpolicy" {
  name        = "FluentBitPolicy"
  path        = "/"
  description = "Fluent Bit Policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "es:ESHttp*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]          
  })
}