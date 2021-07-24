resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-${var.app_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-${var.app_name}"
  role = aws_iam_role.codepipeline_role.id
  policy = <<EOF
{
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Action": [
                                "iam:PassRole"
                            ],
                            "Resource": "*",
                            "Effect": "Allow",
                            "Condition": {
                                "StringEqualsIfExists": {
                                    "iam:PassedToService": [
                                        "cloudformation.amazonaws.com",
                                        "elasticbeanstalk.amazonaws.com",
                                        "ec2.amazonaws.com",
                                        "ecs-tasks.amazonaws.com"
                                    ]
                                }
                            }
                        },
                        {
                            "Action": [
                                "codecommit:CancelUploadArchive",
                                "codecommit:GetBranch",
                                "codecommit:GetCommit",
                                "codecommit:GetUploadArchiveStatus",
                                "codecommit:UploadArchive"
                            ],
                            "Resource": "${aws_codecommit_repository.codecommit.arn}",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "codedeploy:CreateDeployment",
                                "codedeploy:GetApplication",
                                "codedeploy:GetApplicationRevision",
                                "codedeploy:GetDeployment",
                                "codedeploy:GetDeploymentConfig",
                                "codedeploy:RegisterApplicationRevision"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "elasticbeanstalk:*",
                                "ec2:*",
                                "elasticloadbalancing:*",
                                "autoscaling:*",
                                "cloudwatch:*",
                                "s3:*",
                                "sns:*",
                                "cloudformation:*",
                                "rds:*",
                                "sqs:*",
                                "ecs:*"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "lambda:InvokeFunction",
                                "lambda:ListFunctions"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "opsworks:CreateDeployment",
                                "opsworks:DescribeApps",
                                "opsworks:DescribeCommands",
                                "opsworks:DescribeDeployments",
                                "opsworks:DescribeInstances",
                                "opsworks:DescribeStacks",
                                "opsworks:UpdateApp",
                                "opsworks:UpdateStack"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "cloudformation:CreateStack",
                                "cloudformation:DeleteStack",
                                "cloudformation:DescribeStacks",
                                "cloudformation:UpdateStack",
                                "cloudformation:CreateChangeSet",
                                "cloudformation:DeleteChangeSet",
                                "cloudformation:DescribeChangeSet",
                                "cloudformation:ExecuteChangeSet",
                                "cloudformation:SetStackPolicy",
                                "cloudformation:ValidateTemplate"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Action": [
                                "codebuild:BatchGetBuilds",
                                "codebuild:StartBuild"
                            ],
                            "Resource": "*",
                            "Effect": "Allow"
                        },
                        {
                            "Effect": "Allow",
                            "Action": [
                                "devicefarm:ListProjects",
                                "devicefarm:ListDevicePools",
                                "devicefarm:GetRun",
                                "devicefarm:GetUpload",
                                "devicefarm:CreateUpload",
                                "devicefarm:ScheduleRun"
                            ],
                            "Resource": "*"
                        },
                        {
                            "Effect": "Allow",
                            "Action": [
                                "servicecatalog:ListProvisioningArtifacts",
                                "servicecatalog:CreateProvisioningArtifact",
                                "servicecatalog:DescribeProvisioningArtifact",
                                "servicecatalog:DeleteProvisioningArtifact",
                                "servicecatalog:UpdateProduct"
                            ],
                            "Resource": "*"
                        },
                        {
                            "Effect": "Allow",
                            "Action": [
                                "cloudformation:ValidateTemplate"
                            ],
                            "Resource": "*"
                        },
                        {
                            "Effect": "Allow",
                            "Action": [
                                "ecr:DescribeImages"
                            ],
                            "Resource": "*"
                        },
                        {
                            "Effect": "Allow",
                            "Action": "s3:*",
                            "Resource": [
                               "${aws_s3_bucket.codepipeline_bucket.arn}",
                               "${aws_s3_bucket.codepipeline_bucket.arn}/*"
                            ]
                        }
                    ]
                }
EOF
}


resource "aws_cloudwatch_event_rule" "codecommit_rule" {
  name        = "bookstore-codecommit-${var.app_name}"
  description = "Event Rule for any commit to codecommit of Bookstore App - ${var.app_name}"

  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Repository State Change"],
  "resources": ["${aws_codecommit_repository.codecommit.arn}"],
  "detail": {
   "event": ["referenceCreated","referenceUpdated"],
   "referenceType": ["branch"],
   "referenceName": ["${var.code_commit_branch}"]
   }
}
EOF
}

resource "aws_cloudwatch_event_target" "codecommit_rule_target" {
  rule      = aws_cloudwatch_event_rule.codecommit_rule.name
  target_id = "TriggerCodePipeline"
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.cloudwatch_target_role.arn
}

resource "aws_iam_role" "cloudwatch_target_role" {
  name = "cloudwatchtarget-${var.app_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_target_role_policy" {
  name = "cloudwatchtarget-${var.app_name}"
  role = aws_iam_role.cloudwatch_target_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codepipeline:StartPipelineExecution",
      "Resource": "${aws_codepipeline.codepipeline.arn}"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name     = "bookstore-codepipeline-${var.app_name}"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      region           = data.aws_region.current.name
      namespace        = "SourceVariables"
      run_order        = 1
      configuration = {
        PollForSourceChanges    = false
        RepositoryName = aws_codecommit_repository.codecommit.repository_name
        BranchName       = var.code_commit_branch 
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
      region           = data.aws_region.current.name
      namespace        = "BuildVariables"
    }
  }
  stage {
    name = "DeployDevelopment"

    action {
      name             = "DeployDevelopment"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DeployArtifact"]
      version          = "1"
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuilddevdeployment.name
      }
      region           = data.aws_region.current.name
      namespace        = "DeployVariables"
    }
  }
  stage {
    name = "DeployProd"
    action {
      name             = "ApproveProdDeployment"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      version          = "1"
      run_order        = 1
    }
    action {
      name             = "DeployDevelopment"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DeployProductionArtifact"]
      version          = "1"
      run_order        = 2
      configuration = {
        ProjectName = aws_codebuild_project.codebuildproddeployment.name
      }
      region           = data.aws_region.current.name
      namespace        = "DeployProductionVariables"
    }
  }
}
