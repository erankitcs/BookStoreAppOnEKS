module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets
  enable_irsa     = true
  tags = {
    Environment = "Developement"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo ${local.cluster_name} - WG-1"
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
/*    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo ${local.cluster_name} - WG-2"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    }, */
  ]
  workers_additional_policies       = [aws_iam_policy.extenaldnspolicy.arn,aws_iam_policy.albcontrollerpolicy.arn]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}