variable "environment" {
  type        = string
  description = "Environment name"
  default     = "prod"
}

module "s3_prod_website" {
  source                 = "../../modules/s3"
  environment            = var.environment
  bucket_purpose         = "website"
  enable_versioning      = true
  enable_website_hosting = true
  public_access_block    = true
  attach_policy          = false
}

module "dynamodb_visitor_prod" {
  source      = "../../modules/dynamodb"
  environment = var.environment
  table_name  = "visitor"
}

module "lambda_visitor_prod" {
  source      = "../../modules/lambda"
  environment = var.environment

  function_name = "visitor"
  s3_bucket     = "project1-serverless-website-prod"
  s3_key        = "artifacts/visitor.zip"

  role_arn   = "arn:aws:iam::608145123666:role/project1-serverless-lambda-prod"
  table_name = module.dynamodb_visitor_prod.table_name
}

module "api_gateway_prod" {
  source            = "../../modules/api_gateway"
  environment       = var.environment
  lambda_name       = module.lambda_visitor_prod.lambda_name
  lambda_invoke_arn = module.lambda_visitor_prod.lambda_invoke_arn
}
