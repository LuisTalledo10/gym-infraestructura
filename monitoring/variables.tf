variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_user_function_name" {
  description = "Name of the user management Lambda function"
  type        = string
  default     = "gym-user-management"
}

variable "lambda_booking_function_name" {
  description = "Name of the booking Lambda function"
  type        = string
  default     = "gym-booking-system"
}

variable "lambda_payment_function_name" {
  description = "Name of the payment Lambda function"
  type        = string
  default     = "gym-payment-processor"
}

variable "rds_instance_identifier" {
  description = "RDS instance identifier for monitoring"
  type        = string
  default     = "gym-db-instance"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "gym-api"
}

variable "api_gateway_id" {
  description = "ID of the API Gateway"
  type        = string
  default     = ""
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket name for the gym application"
  type        = string
  default     = "gym-bucket-default"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alerts"
  type        = string
  default     = ""
}

variable "cloudwatch_log_retention" {
  description = "Retention period for CloudWatch logs (in days)"
  type        = number
  default     = 14
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/aws/lambda/gym-application"
}

variable "cloudwatch_alarm_threshold" {
  description = "Threshold for CloudWatch alarms"
  type        = number
  default     = 80
}

variable "cloudwatch_alarm_evaluation_periods" {
  description = "Evaluation periods for CloudWatch alarms"
  type        = number
  default     = 5
}

variable "cloudwatch_alarm_period" {
  description = "Period for CloudWatch alarms (in seconds)"
  type        = number
  default     = 60
}

variable "cloudwatch_alarm_statistic" {
  description = "Statistic for CloudWatch alarms"
  type        = string
  default     = "Average"
}

variable "cloudwatch_alarm_comparison_operator" {
  description = "Comparison operator for CloudWatch alarms"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "cloudwatch_notification_topic_arn" {
  description = "ARN of the SNS topic for CloudWatch alarm notifications"
  type        = string
  default     = ""
}
