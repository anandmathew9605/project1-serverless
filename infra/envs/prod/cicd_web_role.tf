resource "aws_iam_role" "github_web_prod" {
  name = "github-web-prod"

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
            # restrict to PRs to main OR pushes to main, adapt as you like
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
          "s3:PutObjectAcl",
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