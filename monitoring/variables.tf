variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_user_function_name" {
  description = "Nombre de la función Lambda para usuarios"
  type        = string
  default     = "gym-user-management"
}

variable "lambda_booking_function_name" {
  description = "Nombre de la función Lambda para reservas"
  type        = string
  default     = "gym-booking-system"
}

variable "lambda_payment_function_name" {
  description = "Nombre de la función Lambda para pagos"
  type        = string
  default     = "gym-payment-processor"
}

variable "rds_instance_identifier" {
  description = "Identificador de la instancia RDS"
  type        = string
  default     = "gym-db-instance"
}

variable "api_gateway_name" {
  description = "Nombre del API Gateway"
  type        = string
  default     = "gym-api"
}

variable "s3_bucket_name" {
  description = "Nombre del bucket S3 principal"
  type        = string
  default     = "gym-bucket-default"
}

variable "sns_topic_arn" {
  description = "ARN del tópico SNS para alertas"
  type        = string
  default     = "arn:aws:sns:us-east-1:123456789012:default-topic"
}
