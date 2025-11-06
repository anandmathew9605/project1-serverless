resource "aws_lambda_function" "visitor" {
  function_name = "project1-serverless-visitor-dev"

  s3_bucket = "project1-serverless-backend-artifact"
  s3_key    = "envs/dev/visitor.zip"

  handler = "app.lambda_handler"
  runtime = "python3.11"
  role    = aws_iam_role.lambda_role.arn
  timeout = 10

  environment {
    variables = {
      TABLE_NAME = "project1-serverless-visitor-dev"
    }
  }
}
