resource "aws_dynamodb_table" "visitor_prod" {
  name         = "project1-serverless-visitor-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }
}
