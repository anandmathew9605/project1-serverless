resource "aws_iam_role" "lambda_dev" {
  name = "project1-serverless-lambda-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "lambda.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dev_policy" {
  name = "project1-serverless-lambda-dev-policy"
  role = aws_iam_role.lambda_dev.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-visitor-dev"
      },
      {
        Effect   = "Allow",
        Action   = "logs:*",
        Resource = "arn:aws:logs:ap-south-1:608145123666:log-group:/aws/lambda/project1-serverless-visitor-dev:*"
      },
      {
        Effect   = "Allow",
        Action   = "lambda:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_prod" {
  name = "project1-serverless-lambda-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "lambda.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_prod_policy" {
  name = "project1-serverless-lambda-prod-policy"
  role = aws_iam_role.lambda_prod.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-visitor-prod"
      },
      {
        Effect   = "Allow",
        Action   = "logs:*",
        Resource = "arn:aws:logs:ap-south-1:608145123666:log-group:/aws/lambda/project1-serverless-visitor-prod:*"
      },
      {
        Effect   = "Allow",
        Action   = "lambda:*",
        Resource = "*"
      }
    ]
  })
}
