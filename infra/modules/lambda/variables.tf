// modules/lambda/variables.tf

variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "environment" {
  type        = string
  description = "Environment name (development or production)"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket name that stores the Lambda artifact"
}

variable "s3_key" {
  type        = string
  description = "Path to Lambda artifact in S3"
}

variable "role_arn" {
  type        = string
  description = "IAM role ARN for Lambda execution"
}

variable "handler" {
  type        = string
  default     = "app.lambda_handler"
}

variable "runtime" {
  type        = string
  default     = "python3.11"
}

variable "timeout" {
  type        = number
  default     = 10
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name used by the Lambda"
}