variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "gym-user-pool"
}

variable "client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
  default     = "gym-web-client"
}

variable "domain_name" {
  description = "Domain name for the Cognito User Pool"
  type        = string
  default     = "gym-auth-domain"
}

variable "identity_pool_name" {
  description = "Name of the Cognito Identity Pool"
  type        = string
  default     = "gym-identity-pool"
}

variable "callback_urls" {
  description = "List of callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000/callback"]
}

variable "logout_urls" {
  description = "List of logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["http://localhost:3000/logout"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "api_gateway_arn" {
  description = "ARN of the API Gateway for IAM policies"
  type        = string
  default     = ""
}

variable "enable_mfa" {
  description = "Enable Multi-Factor Authentication"
  type        = bool
  default     = false
}

variable "mfa_configuration" {
  description = "MFA configuration (OFF, ON, OPTIONAL)"
  type        = string
  default     = "OPTIONAL"
}

variable "password_minimum_length" {
  description = "Minimum length for user passwords"
  type        = number
  default     = 8
}

variable "auto_verified_attributes" {
  description = "Attributes to be auto-verified"
  type        = list(string)
  default     = ["email"]
}
