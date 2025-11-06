resource "aws_lambda_function" "visitor" {
  function_name = "project1-serverless-visitor-dev"
  filename      = "../../../backend/artifacts/visitor.zip"
  source_code_hash = filebase64sha256("../../../backend/artifacts/visitor.zip")

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
