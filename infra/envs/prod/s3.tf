resource "aws_s3_bucket" "prod_website" {
  bucket = "project1-serverless-prod-website"
}

resource "aws_s3_bucket_versioning" "prod_website" {
  bucket = aws_s3_bucket.prod_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "prod_website" {
  bucket = aws_s3_bucket.prod_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}