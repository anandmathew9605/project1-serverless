// modules/lambda/outputs.tf

output "lambda_name" {
  value       = aws_lambda_function.this.function_name
  description = "Lambda function name"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "Lambda ARN"
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.this.invoke_arn
  description = "Lambda invoke ARN for API Gateway integration"
}