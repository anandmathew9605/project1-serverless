resource "aws_dynamodb_table" "visitor_dev" {
  name         = "project1-serverless-visitor-dev"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }
}
