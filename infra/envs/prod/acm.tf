provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"

  default_tags {
    tags = {
      project = "project1-serverless"
      managed = "terraform"
    }
  }
}

resource "aws_acm_certificate" "prod" {
  provider          = aws.us_east_1
  domain_name       = "serverless.anandmathew.site"
  validation_method = "DNS"
}

locals {
  acm_val = tolist(aws_acm_certificate.prod.domain_validation_options)[0]
}

resource "aws_route53_record" "acm_validation" {
  zone_id = "Z03061303E440FJRS5KB1"
  name    = local.acm_val.resource_record_name
  type    = local.acm_val.resource_record_type
  ttl     = 60
  records = [local.acm_val.resource_record_value]
}

resource "aws_acm_certificate_validation" "prod" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.prod.arn
  validation_record_fqdns = [aws_route53_record.acm_validation.fqdn]
}