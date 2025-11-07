// modules/api_gateway/variables.tf

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function to integrate"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function"
}
