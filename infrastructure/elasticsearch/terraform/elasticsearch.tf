provider "aws" {
  region = "us-east-1"
}

variable "domain" {
  default = "bookstore"
}

variable "vpc" {}

variable "hosted_zone" {
    description = "Hosted Zone name for ACM and DNS."
    //default = "techenvision.net"
    type    = string
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc
  }
}

data "aws_subnet_ids" "privatesubnets" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    SubnetType = "private"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "zone" {
  name         = var.hosted_zone
  private_zone = false
}

## Required for VPC and Certificate.
#resource "aws_iam_service_linked_role" "es" {
#  aws_service_name = "es.amazonaws.com"
#}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "_%@"
  upper            = true
  lower            = true
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
}

resource "aws_security_group" "es" {
  name        = "${var.vpc}-elasticsearch-${var.domain}"
  description = "Elastic Search Security Group."
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block,
    ]
  }
}

resource "aws_acm_certificate" "es_cert" {
  domain_name       = "*.es.bookstore.${var.hosted_zone}"
  validation_method = "DNS"
  subject_alternative_names = [
      "es.bookstore.${var.hosted_zone}"
  ]
  tags = {
    Application = "elasticsearch-bookstore"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "es_r53_records" {
  for_each = {
    for dvo in aws_acm_certificate.es_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "es_cert_validation" {
  certificate_arn         = aws_acm_certificate.es_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.es_r53_records : record.fqdn]
}


resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    ## Even number of nodes for two az deployment.
    instance_count = 2
    instance_type = "t3.medium.elasticsearch"
    dedicated_master_enabled = false
    ### Required for multiple subnets.
    zone_awareness_enabled   = true
    warm_enabled             = false
  }
  ebs_options {
      ebs_enabled  = true
      volume_type  = "gp2"
      volume_size  = 100
  }
  vpc_options {
    subnet_ids = [
      for s in data.aws_subnet_ids.privatesubnets.ids : s
    ]

    security_group_ids = [aws_security_group.es.id]
  }
 access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:ESHttp*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
    }
  ]
}
POLICY
encrypt_at_rest {
    enabled = true
}
node_to_node_encryption {
    enabled = true
}
domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
    custom_endpoint_enabled = true
    custom_endpoint         = "es.bookstore.${var.hosted_zone}"
    custom_endpoint_certificate_arn = aws_acm_certificate.es_cert.arn
}
advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options {
        master_user_name = "bookstore"
        master_user_password = random_password.password.result
    }
}
tags = {
    Domain = "Bookstore"
  }
}

resource "aws_route53_record" "custom_es_r53_records" {
  allow_overwrite = true
  name            = aws_elasticsearch_domain.es.domain_endpoint_options[0].custom_endpoint
  records         = [aws_elasticsearch_domain.es.endpoint]
  ttl             = 60
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.zone.zone_id
}


output "es_password" {
  description = "Password for Elastic Search User."
  value       = aws_elasticsearch_domain.es.advanced_security_options[0].master_user_options[0].master_user_password
}

output "es_user" {
  description = "Password for Elastic Search User."
  value       = aws_elasticsearch_domain.es.advanced_security_options[0].master_user_options[0].master_user_name
}

output "es_endpoint" {
  description = "Elastic Search Endpoint."
  value       = aws_elasticsearch_domain.es.endpoint
}

output "es_custom_endpoint" {
  description = "Elastic Search Custome Endpoint."
  value       = aws_elasticsearch_domain.es.domain_endpoint_options[0].custom_endpoint
}

output "es_kibana_endpoint" {
  description = "Elastic Search Kibana Endpoint."
  value       = aws_elasticsearch_domain.es.kibana_endpoint
}