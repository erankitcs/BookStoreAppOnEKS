variable "domain" {
  default = "bookstore"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

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

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_count = 1
    instance_type = "t3.medium.elasticsearch"
    dedicated_master_enabled = false
    zone_awareness_enabled   = false
    warm_enabled             = false
  }
  ebs_options {
      ebs_enabled  = true
      volume_type  = "gp2"
      volume_size  = 100
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

output "es_kibana_endpoint" {
  description = "Elastic Search Kibana Endpoint."
  value       = aws_elasticsearch_domain.es.kibana_endpoint
}