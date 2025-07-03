output "admin_role_arn" {
  value = aws_iam_role.admin_role.arn
}

output "sns_topic_arn" {
  description = "ARN del topic SNS para alertas"
  value       = aws_sns_topic.gym_alerts.arn
}
