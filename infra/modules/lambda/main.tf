// modules/lambda/main.tf

resource "aws_lambda_function" "this" {
  function_name = "project1-serverless-${var.function_name}-${var.environment}"

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  handler = var.handler
  runtime = var.runtime
  role    = var.role_arn
  timeout = var.timeout

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}