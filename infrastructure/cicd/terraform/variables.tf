variable "environment" {
    description = "Environment of the Pipeline"
    default = "developement"
    type = string
}

variable "app_name" {
    description = "App Name  of the Pipeline"
    default = "resource-api"
    type = string
}

variable "code_commit_branch" {
    description = "Branch to use for CI/CD Pipeline."
    default = "master"
    type = string
}

variable "buildspec_location" {
    description = "Buil Spec File Location"
    default = "infra/codebuild/buildspec.yml"
    type = string
}

variable "devdeployspec_location" {
    description = "Develoment Deploy Build Spec Location."
    default = "infra/codebuild/development/buildspec.yml"
    type = string
}


