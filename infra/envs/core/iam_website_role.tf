resource "aws_iam_role" "web_dev" {
  name = "project1-serverless-web-dev"

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

resource "aws_iam_role_policy" "web_dev_policy" {
  name = "project1-serverless-web-dev-policy"
  role = aws_iam_role.web_dev.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = [
          "arn:aws:s3:::project1-serverless-website-dev",
          "arn:aws:s3:::project1-serverless-website-dev/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "web_prod" {
  name = "project1-serverless-web-prod"

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

resource "aws_iam_role_policy" "web_prod_policy" {
  name = "project1-serverless-web-prod-policy"
  role = aws_iam_role.web_prod.id

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
          "arn:aws:s3:::project1-serverless-website-prod/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions"
        ],
        Resource = "*"
      }
    ]
  })
}

