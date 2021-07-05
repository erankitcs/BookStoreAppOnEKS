resource "aws_iam_policy" "extenaldnspolicy" {
  name        = "ExtenalDNSPolicy"
  path        = "/"
  description = "External DNS policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:ChangeResourceRecordSets",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Action = [
          "route53:ListHostedZones",
           "route53:ListResourceRecordSets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}