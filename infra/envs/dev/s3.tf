resource "aws_s3_bucket" "dev_website" {
  bucket = "project1-serverless-dev-website"
}

resource "aws_s3_bucket_versioning" "dev_website" {
  bucket = aws_s3_bucket.dev_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "dev_website" {
 bucket = aws_s3_bucket.dev_website.id
  index_document {
    suffix = "index.html"
  } 

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "dev_website" {
  bucket = aws_s3_bucket.dev_website.id   

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "dev_website_public" {
  statement {
    sid       = "AllowPublicReadForGetObject"
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dev_website.arn}/*"]
  }
  
}
resource "aws_s3_bucket_policy" "dev_website" {
  bucket = aws_s3_bucket.dev_website.id
  policy = data.aws_iam_policy_document.dev_website_public.json
}