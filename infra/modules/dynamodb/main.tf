// modules/dynamodb/main.tf

resource "aws_dynamodb_table" "this" {
  name         = "project1-serverless-${var.table_name}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = var.partition_key_name

  attribute {
    name = var.partition_key_name
    type = var.partition_key_type
  }
}