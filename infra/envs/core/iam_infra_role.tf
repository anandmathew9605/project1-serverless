resource "aws_iam_role" "infra_dev" {
  name = "project1-serverless-infra-dev"

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

resource "aws_iam_role_policy" "infra_dev_policy" {
  name = "project1-serverless-infra-dev-policy"
  role = aws_iam_role.infra_dev.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "dynamodb:*",
          "lambda:*",
          "iam:*",
          "apigateway:*",
          "logs:*",
          "cloudwatch:*"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "infra_prod" {
  name = "project1-serverless-infra-prod"

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

resource "aws_iam_role_policy" "infra_prod_policy" {
  name = "project1-serverless-infra-prod-policy"
  role = aws_iam_role.infra_prod.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "dynamodb:*",
          "lambda:*",
          "iam:*",
          "apigateway:*",
          "logs:*",
          "cloudwatch:*",
          "acm:*",
          "cloudfront:*",
          "route53:*"
        ],
        Resource = "*"
      }
    ]
  })
}
