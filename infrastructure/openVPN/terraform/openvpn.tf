provider "aws" {
  region = "us-west-2"
}

variable "vpc" {}

variable "ami" {}

variable "keyname" {}

variable "instancetype" {}

variable "allowed_ip_range" {}

variable "vpn_initial_username" {}

#variable "vpn_initial_password" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc
  }
}

data "aws_subnet_ids" "publicsubnets" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    SubnetType = "public"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "random_password" "password" {
  length           = 6
  special          = true
  override_special = "_%@"
  upper            = true
  lower            = true
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
}

### Security Grps.

resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn"
  description = "Open VPN SG."
  vpc_id      = data.aws_vpc.vpc.id

  ingress = [
    {
      description      = "TLS 443 from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [var.allowed_ip_range]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
      security_groups  = null
    },
    {
      description      = "TLS 943 from VPC"
      from_port        = 943
      to_port          = 943
      protocol         = "tcp"
      cidr_blocks      = [var.allowed_ip_range]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
      security_groups  = null
    },
    {
      description      = "TLS 945 from VPC"
      from_port        = 945
      to_port          = 945
      protocol         = "tcp"
      cidr_blocks      = [var.allowed_ip_range]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
      security_groups  = null
    },
    {
      description      = "TLS 1194 from VPC"
      from_port        = 1194
      to_port          = 1194
      protocol         = "tcp"
      cidr_blocks      = [var.allowed_ip_range]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
      security_groups  = null
    }
  ]

  egress = [
    {
      description      = "Outbound from OpenVPN"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
      security_groups  = null
    }
  ]

  tags = {
    Name = "openvpn"
  }
}

resource "aws_iam_role" "openvpn_role" {
  name = "openvpn_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "openvpn"
  }
}

resource "aws_iam_role_policy" "openvpn_policy" {
  name = "openvpn"
  role = aws_iam_role.openvpn_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Deny"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "openvpn_profile" {
  name = "openvpn_profile"
  role = aws_iam_role.openvpn_role.name
  path = "/openvpn/"
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    AuthorizedUserName   = "ec2-user"
    vpc_cidr             = data.aws_vpc.vpc.cidr_block
    vpn_initial_username = var.vpn_initial_username
    vpn_initial_password = random_password.password.result
  }
}


resource "aws_launch_template" "openvpn" {
  name = "openvpn_lt"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.openvpn_profile.name
  }
  image_id = var.ami
  instance_type = var.instancetype
  key_name = var.keyname
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "openvpn"
    }
  }
  user_data = base64encode(data.template_file.cloud_init.rendered)
}

resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = data.aws_subnet_ids.publicsubnets.ids
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.openvpn.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Open VPN Server"
    propagate_at_launch = true
  }
}

### push password into AWS SSM Parameter Store.
resource "aws_ssm_parameter" "secret" {
  name        = "/openvpn/password/${var.vpn_initial_username}"
  description = "Open VPN Admin password."
  type        = "SecureString"
  value       = random_password.password.result

  tags = {
    Name = "openvpn"
  }
}

output "vpnpassword_ps" {
  value = aws_ssm_parameter.secret.name
  description = "Open VPN password Parameter Store name."
  sensitive = false
}