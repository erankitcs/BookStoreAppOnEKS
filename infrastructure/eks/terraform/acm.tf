resource "aws_acm_certificate" "cert" {
  domain_name       = "*.dev.bookstore.${var.hosted_zone}"
  validation_method = "DNS"
  subject_alternative_names = [
      "dev.bookstore.${var.hosted_zone}"
  ]
  tags = {
    Environment = "development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "prod_cert" {
  domain_name       = "*.bookstore.${var.hosted_zone}"
  validation_method = "DNS"
  subject_alternative_names = [
      "bookstore.${var.hosted_zone}"
  ]
  tags = {
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = var.hosted_zone
  private_zone = false
}


resource "aws_route53_record" "dev_r53_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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

resource "aws_route53_record" "prod_r53_records" {
  for_each = {
    for dvo in aws_acm_certificate.prod_cert.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "dev_cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dev_r53_records : record.fqdn]
}

resource "aws_acm_certificate_validation" "prod_cert_validation" {
  certificate_arn         = aws_acm_certificate.prod_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.prod_r53_records : record.fqdn]
}