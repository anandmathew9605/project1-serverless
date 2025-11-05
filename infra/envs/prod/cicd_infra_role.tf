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
      # --- S3 full (state + website buckets)
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

      # --- DynamoDB (state lock table)
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

      # --- IAM (read roles/policies)
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

      # --- CloudFront (read + manage)
      {
        Effect = "Allow",
        Action = [
          "cloudfront:*"
        ],
        Resource = "*"
      },

      # --- ACM (read + request/delete/list tags)
      {
        Effect = "Allow",
        Action = [
          "acm:*"
        ],
        Resource = "*"
      },

      # --- Route53 (zones, records, tags)
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
