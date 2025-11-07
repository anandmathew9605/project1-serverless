resource "aws_apigatewayv2_api" "http_api_prod" {
  name          = "project1-serverless-prod"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration_prod" {
  api_id                 = aws_apigatewayv2_api.http_api_prod.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.visitor_prod.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route_prod" {
  api_id    = aws_apigatewayv2_api.http_api_prod.id
  route_key = "ANY /count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration_prod.id}"
}

resource "aws_apigatewayv2_stage" "default_stage_prod" {
  api_id      = aws_apigatewayv2_api.http_api_prod.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_lambda_prod" {
  statement_id  = "AllowAPIGatewayInvokeProd"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_prod.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api_prod.execution_arn}/*/*"
}
