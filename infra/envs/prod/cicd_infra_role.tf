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
    Version = "2012-10-17"
    Statement = [
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
      {
        Effect = "Allow"
        Action = [ "s3:ListAllMyBuckets" ]
        Resource = "*"
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
        ]
        Resource = "arn:aws:dynamodb:ap-south-1:608145123666:table/project1-serverless-tf-locks"
      },
            
      # CloudFront permissions: Required for managing CDN distributions and performing cache invalidations
      # This allows Terraform to create, update, delete, and invalidate CloudFront distributions for website deployments.
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudfront:DeleteDistribution",
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Resource = "*"
      },
      # ACM permissions: Needed for requesting, describing, listing, deleting, and tagging SSL certificates
      # These permissions enable automated certificate management for secure HTTPS on CloudFront distributions.
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
      # Route53 permissions: Required for managing DNS records and validating certificates
      # This allows Terraform to update DNS records for domain validation and configure aliases for CloudFront.
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:GetHostedZone",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:GetChange"
        ]
        Resource = "*"
      },




      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
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
# Updated policy for cicd  
