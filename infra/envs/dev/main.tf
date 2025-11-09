variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

module "s3_dev_website" {
  source                 = "../../modules/s3"
  environment            = var.environment
  bucket_purpose         = "website"
  enable_versioning      = true
  enable_website_hosting = true
  public_access_block    = false
  attach_policy          = true
  policy_json            = file("../core/s3_dev_website.json")
}

module "dynamodb_visitor_dev" {
  source      = "../../modules/dynamodb"
  environment = var.environment
  table_name  = "visitor"
}

module "lambda_visitor_dev" {
  source      = "../../modules/lambda"
  environment = var.environment

  function_name = "visitor"
  s3_bucket     = "project1-serverless-website-dev"
  s3_key        = "artifacts/visitor.zip"

  role_arn   = "arn:aws:iam::608145123666:role/project1-serverless-lambda-dev"
  table_name = module.dynamodb_visitor_dev.table_name
}

module "api_gateway_dev" {
  source            = "../../modules/api_gateway"
  environment       = var.environment
  lambda_name       = module.lambda_visitor_dev.lambda_name
  lambda_invoke_arn = module.lambda_visitor_dev.lambda_invoke_arn
}
