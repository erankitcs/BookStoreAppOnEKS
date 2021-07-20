resource "aws_iam_role" "codebuild_iam" {
  name = "codebuild-${var.app_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_iam.name
  name = "codebuild-policy-${var.app_name}"
  policy = <<POLICY
{
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Resource": ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/bookstore-${var.app_name}","arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/bookstore-${var.app_name}:*"
                            ],
                            "Action": [
                                "logs:CreateLogGroup",
                                "logs:CreateLogStream",
                                "logs:PutLogEvents"
                            ]
                        },
                        {
                            "Effect": "Allow",
                            "Action": "ecr:*",
                            "Resource": "*"
                        },
                        {
                            "Effect": "Allow",
                            "Resource": [
                              "${aws_s3_bucket.codepipeline_bucket.arn}",
                              "${aws_s3_bucket.codepipeline_bucket.arn}/*"
                            ],
                            "Action": [
                                "s3:PutObject",
                                "s3:GetObject",
                                "s3:GetObjectVersion",
                                "s3:GetBucketAcl",
                                "s3:GetBucketLocation"
                            ]
                        },
                        {
                            "Effect": "Allow",
                            "Resource": [
                                     "${aws_codecommit_repository.codecommit.arn}"
                            ],
                            "Action": [
                                "codecommit:GitPull"
                            ]
                        },
                        {
                            "Effect": "Allow",
                            "Action": [
                                "codebuild:CreateReportGroup",
                                "codebuild:CreateReport",
                                "codebuild:UpdateReport",
                                "codebuild:BatchPutTestCases"
                            ],
                            "Resource": "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/bookstore-${var.app_name}-*"
                        }
                    ]
}
POLICY
}


resource "aws_codebuild_project" "codebuild" {
  name          = "bookstore-${var.app_name}"
  description   = "CodeBuild project for the App- ${var.app_name}"
  build_timeout = "60"
  queued_timeout = "480"
  service_role  = aws_iam_role.codebuild_iam.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  badge_enabled = false
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "ECR_URL"
      value = aws_ecr_repository.ecr.repository_url
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
  }
  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.codecommit.clone_url_http
    buildspec       = var.buildspec_location
  }
  source_version    = var.code_commit_branch
  tags = {
    Environment = "dev"
  }
}


resource "aws_codebuild_project" "codebuilddevdeployment" {
  name          = "bookstore-development-deploy-${var.app_name}"
  description   = "CodeBuild project for Deployment the App- ${var.app_name} in Development Namespace."
  build_timeout = "60"
  queued_timeout = "480"
  service_role  = aws_iam_role.codebuild_iam.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  badge_enabled = false
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = data.terraform_remote_state.eks_cluster.outputs.cluster_name
    }
  }
  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.codecommit.clone_url_http
    buildspec       = var.devdeployspec_location
  }
  source_version    = var.code_commit_branch
  tags = {
    Environment = "dev"
  }
}


resource "aws_codebuild_project" "codebuildproddeployment" {
  name          = "bookstore-development-deploy-${var.app_name}"
  description   = "CodeBuild project for Deployment the App- ${var.app_name} in Prodcution Namespace."
  build_timeout = "60"
  queued_timeout = "480"
  service_role  = aws_iam_role.codebuild_iam.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  badge_enabled = false
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "EKS_CLUSTER_NAME"
      value = data.terraform_remote_state.eks_cluster.outputs.cluster_name
    }
  }
  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.codecommit.clone_url_http
    buildspec       = var.proddeployspec_location
  }
  source_version    = var.code_commit_branch
  tags = {
    Environment = "prod"
  }
}