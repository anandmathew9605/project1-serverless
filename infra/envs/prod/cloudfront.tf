resource "aws_cloudfront_distribution" "prod" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["serverless.anandmathew.site"]

  origin {
    domain_name = aws_s3_bucket.prod_website.bucket_regional_domain_name
    origin_id   = "s3-prod-website"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.prod_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-prod-website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.prod.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  tags = {
    project = "project1-serverless"
    managed = "terraform"
  }
}

resource "aws_route53_record" "prod_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "serverless"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.prod.domain_name
    zone_id                = aws_cloudfront_distribution.prod.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_cloudfront_origin_access_identity" "prod_oai" {
  comment = "Origin Access Identity for production CloudFront distribution"
}

data "aws_iam_policy_document" "prod_allow_cf_oai" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.prod_oai.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.prod_website.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "prod" {
  bucket = aws_s3_bucket.prod_website.id
  policy = data.aws_iam_policy_document.prod_allow_cf_oai.json
}

