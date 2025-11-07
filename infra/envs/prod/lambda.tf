resource "aws_lambda_function" "visitor_prod" {
  function_name = "project1-serverless-visitor-prod"

  s3_bucket = "project1-serverless-backend-artifact"
  s3_key    = "envs/prod/visitor.zip"

  handler = "app.lambda_handler"
  runtime = "python3.11"
  role    = aws_iam_role.lambda_role_prod.arn
  timeout = 10

  environment {
    variables = {
      TABLE_NAME = "project1-serverless-visitor-prod"
    }
  }
}
