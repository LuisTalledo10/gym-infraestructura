output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "db_instance_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.default.id
}