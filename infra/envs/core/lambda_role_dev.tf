resource "aws_iam_role" "lambda_role" {
  name = "project1-serverless-lambda-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "project1-serverless-lambda-dev-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # DynamoDB access
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem",
          "dynamodb:Query"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-visitor-dev"
      },

      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:ap-south-1:608145123666:log-group:/aws/lambda/project1-serverless-visitor-dev:*"
      }
    ]
  })
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "ARN of the Lambda execution role"
}