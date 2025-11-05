resource "aws_iam_role" "github_infra_prod" {
  name = "github-infra-prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = "arn:aws:iam::608145123666:oidc-provider/token.actions.githubusercontent.com" }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            # allow PR plan and push/apply to main
            "token.actions.githubusercontent.com:sub" = [
              "repo:anandmathew9605/project1-serverless:ref:refs/heads/main",
              "repo:anandmathew9605/project1-serverless:ref:refs/pull/*"
            ]
          }
        }
      }
    ]
  })
}

# Minimal (slightly permissive) policy to unblock Terraform runs for prod.
# We'll tighten this later. Grants S3 full control on project buckets/state,
# DynamoDB locking actions, CloudFront manage & ACM describe/validate actions,
# and read IAM role policy metadata.
resource "aws_iam_role_policy" "github_infra_prod_policy" {
  name = "github-infra-prod-policy"
  role = aws_iam_role.github_infra_prod.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 full for state + prod & dev website buckets (keeps Terraform happy)
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::project1-serverless-terraform-state",
          "arn:aws:s3:::project1-serverless-terraform-state/*",
          "arn:aws:s3:::project1-serverless-prod-website",
          "arn:aws:s3:::project1-serverless-prod-website/*",
          "arn:aws:s3:::project1-serverless-dev-website",
          "arn:aws:s3:::project1-serverless-dev-website/*"
        ]
      },
      # allow listing buckets (Terraform sometimes queries)
      {
        Effect   = "Allow"
        Action   = ["s3:ListAllMyBuckets"]
        Resource = "*"
      },
      # DynamoDB lock table actions
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-tf-locks"
      },
      # CloudFront and ACM minimal management rights (broad for quick start)
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetDistribution",
          "cloudfront:ListDistributions",
          "cloudfront:GetDistributionConfig",
          "cloudfront:UpdateDistribution",
          "cloudfront:CreateDistribution",
          "cloudfront:DeleteDistribution"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:RequestCertificate",
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:DeleteCertificate",
          "acm:AddTagsToCertificate"
        ]
        Resource = "*"
      },
      # IAM read actions (Terraform reads role/policy metadata)
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies"
        ]
        Resource = [
          "arn:aws:iam::608145123666:role/github-infra-prod",
          "arn:aws:iam::608145123666:role/github-web-prod",
          "arn:aws:iam::608145123666:role/github-infra-dev",
          "arn:aws:iam::608145123666:role/github-web-dev"
        ]
      }
    ]
  })
}