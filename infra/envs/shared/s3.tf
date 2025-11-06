resource "aws_s3_bucket" "artifact" {
  bucket = "project1-serverless-backend-artifact"
}

resource "aws_s3_bucket_versioning" "deploy" {
  bucket = aws_s3_bucket.artifact.id
  versioning_configuration {
    status = "Enabled"
  }
}

