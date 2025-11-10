resource "aws_cloudfront_origin_access_identity" "prod" {
  comment = "OAI for project1-serverless-website-prod"
}

resource "aws_cloudfront_distribution" "prod" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["serverless.anandmathew.site"]

  origin {
    domain_name = "project1-serverless-website-prod.s3.ap-south-1.amazonaws.com"
    origin_id   = "s3_prod_website"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.prod.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3_prod_website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:608145123666:certificate/d54e5ffc-0954-4b82-ad46-6bd13170bd93"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  tags = {
    project     = "project1-serverless"
    environment = "production"
    managed     = "terraform"
  }
}

data "aws_iam_policy_document" "prod_allow_cf_oai" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.prod.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::project1-serverless-website-prod/*"]
  }
}

resource "aws_s3_bucket_policy" "prod" {
  bucket = "project1-serverless-website-prod"
  policy = data.aws_iam_policy_document.prod_allow_cf_oai.json
}

resource "aws_route53_record" "prod" {
  zone_id = "Z03061303E440FJRS5KB1"
  name    = "serverless"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.prod.domain_name
    zone_id                = aws_cloudfront_distribution.prod.hosted_zone_id
    evaluate_target_health = false
  }
}
