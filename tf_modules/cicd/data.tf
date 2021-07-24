data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

//data "terraform_remote_state" "eks_cluster" {
//  backend = "local"
//  config = {
//    path = "${path.module}/../../eks/terraform/terraform.tfstate"
//  }
//}