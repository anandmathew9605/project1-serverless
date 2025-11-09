resource "aws_iam_role" "backend_dev" {
  name = "project1-serverless-backend-dev"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:anandmathew9605/project1-serverless:*"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "backend_dev_policy" {
  name = "project1-serverless-backend-dev-policy"
  role = aws_iam_role.backend_dev.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = [
          "arn:aws:s3:::project1-serverless-website-dev",
          "arn:aws:s3:::project1-serverless-website-dev/artifacts/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:*"
        ],
        Resource = "arn:aws:lambda:ap-south-1:608145123666:function:project1-serverless-visitor-dev"
      },
      {
        Effect   = "Allow",
        Action   = "logs:*",
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "backend_prod" {
  name = "project1-serverless-backend-prod"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:anandmathew9605/project1-serverless:*"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "backend_prod_policy" {
  name = "project1-serverless-backend-prod-policy"
  role = aws_iam_role.backend_prod.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = [
          "arn:aws:s3:::project1-serverless-website-prod",
          "arn:aws:s3:::project1-serverless-website-prod/artifacts/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:*"
        ],
        Resource = "arn:aws:lambda:ap-south-1:608145123666:function:project1-serverless-visitor-prod"
      },
      {
        Effect   = "Allow",
        Action   = "logs:*",
        Resource = "*"
      }
    ]
  })
}
