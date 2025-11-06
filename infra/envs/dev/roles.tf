resource "aws_iam_role" "github_infra_dev" {
  name = "project1-serverless-infra-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:anandmathew9605/project1-serverless:ref:refs/heads/dev"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_terraform_dev_policy" {
  name = "project1-serverless-infra-dev"
  role = aws_iam_role.github_infra_dev.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::project1-serverless-terraform-state",
          "arn:aws:s3:::project1-serverless-terraform-state/*",
          "arn:aws:s3:::project1-serverless-dev-website",
          "arn:aws:s3:::project1-serverless-dev-website/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-tf-locks"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies"

        ],
        Resource = [
          "arn:aws:iam::608145123666:role/github-infra-dev",
          "arn:aws:iam::608145123666:role/github-web-dev"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "github_web_dev" {
  name = "project1-serverless-web-dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:anandmathew9605/project1-serverless:ref:refs/heads/dev"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_deploy_frontend_dev_policy" {
  name = "project1-serverless-web-dev"
  role = aws_iam_role.github_web_dev.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::project1-serverless-dev-website",
          "arn:aws:s3:::project1-serverless-dev-website/*"
        ]
      }
    ]
  })
}

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
  name = "project1-serverless-lambda-dev"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem",
          "dynamodb:Query"
        ],
        Resource = "arn:aws:dynamodb:ap-south-1:*:table/project1-serverless-visitor-dev"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

