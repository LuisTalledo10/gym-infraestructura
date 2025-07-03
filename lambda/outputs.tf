output "user_management_arn" {
  description = "ARN of the user management Lambda function"
  value       = aws_lambda_function.user_management.arn
}

output "booking_system_arn" {
  description = "ARN of the booking system Lambda function"
  value       = aws_lambda_function.booking_system.arn
}

output "payment_processor_arn" {
  description = "ARN of the payment processor Lambda function"
  value       = aws_lambda_function.payment_processor.arn
}

output "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  value       = aws_security_group.lambda_sg.id
}
