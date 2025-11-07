resource "aws_iam_role" "github_infra_prod" {
  name = "github-infra-prod"

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

resource "aws_iam_role_policy" "github_infra_prod_policy" {
  name = "github-infra-prod-policy"
  role = aws_iam_role.github_infra_prod.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = [
          "arn:aws:s3:::project1-serverless-terraform-state",
          "arn:aws:s3:::project1-serverless-terraform-state/*",
          "arn:aws:s3:::project1-serverless-prod-website",
          "arn:aws:s3:::project1-serverless-prod-website/*",
          "arn:aws:s3:::project1-serverless-dev-website",
          "arn:aws:s3:::project1-serverless-dev-website/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["s3:ListAllMyBuckets"],
        Resource = "*"
      },


      {
        Effect = "Allow",
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
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ],
        Resource = [
          "arn:aws:iam::608145123666:role/github-infra-prod",
          "arn:aws:iam::608145123666:role/github-web-prod",
          "arn:aws:iam::608145123666:role/github-infra-dev",
          "arn:aws:iam::608145123666:role/github-web-dev"
        ]
      },


      {
        Effect = "Allow",
        Action = [
          "cloudfront:*"
        ],
        Resource = "*"
      },


      {
        Effect = "Allow",
        Action = [
          "acm:*"
        ],
        Resource = "*"
      },


      {
        Effect = "Allow",
        Action = [
          "route53:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "github_web_prod" {
  name = "github-web-prod"

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

resource "aws_iam_role_policy" "github_web_prod_policy" {
  name = "github-web-prod-policy"
  role = aws_iam_role.github_web_prod.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::project1-serverless-prod-website",
          "arn:aws:s3:::project1-serverless-prod-website/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role_prod" {
  name = "project1-serverless-lambda-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_role_policy_prod" {
  name = "project1-serverless-lambda-prod"
  role = aws_iam_role.lambda_role_prod.id

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
        Resource = "arn:aws:dynamodb:ap-south-1:*:table/project1-serverless-visitor-prod"
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

resource "aws_iam_role" "github_backend_prod" {
  name = "project1-serverless-backend-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:anandmathew9605/project1-serverless:*"
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_backend_prod_policy" {
  name = "project1-serverless-backend-prod"
  role = aws_iam_role.github_backend_prod.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::project1-serverless-backend-artifact",
          "arn:aws:s3:::project1-serverless-backend-artifact/envs/prod/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:GetFunction"
        ],
        Resource = "arn:aws:lambda:ap-south-1:*:function:project1-serverless-visitor-prod"
      }
    ]
  })
}
