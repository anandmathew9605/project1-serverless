// modules/s3/main.tf

resource "aws_s3_bucket" "this" {
  bucket = "project1-serverless-${var.bucket_purpose}-${var.environment}"
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document { suffix = var.index_document_suffix }
  error_document { key = var.error_document_key }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.public_access_block ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy_json
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count  = var.enable_ownership_controls ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}