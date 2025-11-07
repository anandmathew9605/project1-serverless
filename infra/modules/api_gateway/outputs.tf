// modules/api_gateway/outputs.tf

output "api_id" {
  value       = aws_apigatewayv2_api.this.id
  description = "API Gateway ID"
}

output "api_endpoint" {
  value       = aws_apigatewayv2_api.this.api_endpoint
  description = "Base URL of the deployed API"
}
