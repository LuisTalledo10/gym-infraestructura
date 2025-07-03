output "dashboard_url" {
  description = "URL del dashboard de CloudWatch"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.gym_infrastructure.dashboard_name}"
}

output "dashboard_name" {
  description = "Nombre del dashboard de CloudWatch"
  value       = aws_cloudwatch_dashboard.gym_infrastructure.dashboard_name
}

output "alarm_arns" {
  description = "ARNs de las alarmas de CloudWatch"
  value = {
    lambda_errors    = [for alarm in aws_cloudwatch_metric_alarm.lambda_errors : alarm.arn]
    rds_cpu         = aws_cloudwatch_metric_alarm.rds_cpu.arn
    api_gateway_errors = aws_cloudwatch_metric_alarm.api_gateway_errors.arn
  }
}
