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
