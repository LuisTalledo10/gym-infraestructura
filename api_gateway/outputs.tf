output "api_url" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "api_gateway_arn" {
  description = "ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "api_gateway_domain_name" {
  description = "Domain name of the API Gateway"
  value       = "${aws_api_gateway_rest_api.api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_gateway_stage_name" {
  description = "Name of the API Gateway stage"
  value       = "prod"
}

# Data source for current AWS region
data "aws_region" "current" {}
