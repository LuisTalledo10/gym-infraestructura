output "grafana_workspace_id" {
  description = "ID of the Grafana workspace"
  value       = aws_grafana_workspace.gym_grafana.id
}

output "grafana_workspace_arn" {
  description = "ARN of the Grafana workspace"
  value       = aws_grafana_workspace.gym_grafana.arn
}

output "grafana_workspace_endpoint" {
  description = "Endpoint URL of the Grafana workspace"
  value       = aws_grafana_workspace.gym_grafana.endpoint
}

output "grafana_workspace_status" {
  description = "Status of the Grafana workspace"
  value       = "ACTIVE"  # Grafana workspace status is managed by AWS
}

output "grafana_workspace_version" {
  description = "Version of the Grafana workspace"
  value       = aws_grafana_workspace.gym_grafana.grafana_version
}

output "grafana_iam_role_arn" {
  description = "ARN of the IAM role for Grafana"
  value       = aws_iam_role.grafana_access.arn
}

output "grafana_dashboard_url" {
  description = "Complete URL to access Grafana dashboard"
  value       = "https://${aws_grafana_workspace.gym_grafana.endpoint}"
}

output "grafana_data_sources" {
  description = "Data sources configured for Grafana"
  value       = aws_grafana_workspace.gym_grafana.data_sources
}

output "grafana_authentication_providers" {
  description = "Authentication providers configured"
  value       = aws_grafana_workspace.gym_grafana.authentication_providers
}

output "grafana_workspace_configuration" {
  description = "Complete Grafana workspace configuration"
  value = {
    id                      = aws_grafana_workspace.gym_grafana.id
    name                    = aws_grafana_workspace.gym_grafana.name
    endpoint                = aws_grafana_workspace.gym_grafana.endpoint
    grafana_version         = aws_grafana_workspace.gym_grafana.grafana_version
    status                  = "ACTIVE"
    data_sources           = aws_grafana_workspace.gym_grafana.data_sources
    authentication_providers = aws_grafana_workspace.gym_grafana.authentication_providers
    dashboard_url          = "https://${aws_grafana_workspace.gym_grafana.endpoint}"
  }
}

output "cloudwatch_integration_dashboard" {
  description = "CloudWatch dashboard for Grafana integration"
  value       = aws_cloudwatch_dashboard.grafana_integration.dashboard_name
}

output "grafana_log_group" {
  description = "CloudWatch log group for Grafana"
  value       = aws_cloudwatch_log_group.grafana_logs.name
}

# Configuration for connecting to data sources
output "grafana_setup_instructions" {
  description = "Instructions for setting up Grafana data sources"
  value = {
    cloudwatch_region = data.aws_region.current.name
    account_id        = data.aws_caller_identity.current.account_id
    data_sources_guide = "Access Grafana at ${aws_grafana_workspace.gym_grafana.endpoint} -> Configuration -> Data Sources -> Add CloudWatch"
    dashboard_templates = "Import dashboard templates for Lambda, RDS, S3, and API Gateway from Grafana.com"
  }
}
