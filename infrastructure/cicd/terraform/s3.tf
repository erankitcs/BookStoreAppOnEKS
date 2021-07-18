resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "bookstore-codepipeline-${var.app_name}-${lower(random_string.bucket_suffix.result)}"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "codepipeline_bucket_policy" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "SSEAndSSLPolicy"
    Statement = [
      {
        Sid       = "DenyUnEncryptedObjectUploads"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.codepipeline_bucket.arn}/*",
        ]
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      },
      {
        Sid       = "DenyInsecureConnections"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.codepipeline_bucket.arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}