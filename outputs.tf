output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "api_url" {
  value = module.api_gateway.api_url
}

output "lambda_function_arn" {
  value = module.lambda.user_management_arn
}

# Comentados temporalmente hasta desplegar monitoreo
# output "monitoring_dashboard_url" {
#   description = "URL del dashboard de monitoreo"
#   value       = module.monitoring.dashboard_url
# }

# output "monitoring_dashboard_name" {
#   description = "Nombre del dashboard de CloudWatch"
#   value       = module.monitoring.dashboard_name
# }

# CloudFront Outputs
output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = "https://${module.cloudfront.cloudfront_domain_name}"
}

# Cognito Outputs
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = module.cognito.user_pool_client_id
}

output "cognito_identity_pool_id" {
  description = "ID of the Cognito Identity Pool"
  value       = module.cognito.identity_pool_id
}

output "cognito_domain" {
  description = "Domain of the Cognito User Pool"
  value       = module.cognito.user_pool_domain
}

output "cognito_config" {
  description = "Complete Cognito configuration for frontend applications"
  value       = module.cognito.cognito_config
  sensitive   = false
}

# Application URLs
output "gym_application_url" {
  description = "Main URL for accessing the gym application"
  value       = "https://${module.cloudfront.cloudfront_domain_name}"
}

output "gym_api_url" {
  description = "API URL for the gym application"
  value       = "https://${module.api_gateway.api_gateway_domain_name}/prod"
}

output "gym_auth_url" {
  description = "Authentication URL for the gym application"
  value       = "https://${module.cognito.user_pool_domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}

# Data source for current AWS region
data "aws_region" "current" {}
