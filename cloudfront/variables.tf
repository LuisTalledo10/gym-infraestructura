variable "api_gateway_domain_name" {
  description = "Domain name of the API Gateway"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket for static content"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "enable_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "S3 bucket for CloudFront logs"
  type        = string
  default     = ""
}
