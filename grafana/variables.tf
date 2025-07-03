variable "workspace_name" {
  description = "Name of the Grafana workspace"
  type        = string
  default     = "gym-infrastructure-grafana"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
  default     = ""
}

variable "rds_instance_identifier" {
  description = "RDS instance identifier for monitoring"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "enable_enterprise_features" {
  description = "Enable Grafana Enterprise features"
  type        = bool
  default     = false
}

variable "enable_saml" {
  description = "Enable SAML authentication"
  type        = bool
  default     = false
}

variable "saml_metadata_url" {
  description = "SAML metadata URL for authentication"
  type        = string
  default     = ""
}

variable "enable_alerting" {
  description = "Enable unified alerting in Grafana"
  type        = bool
  default     = true
}

variable "organization_role_attribute" {
  description = "SAML attribute for organization role"
  type        = string
  default     = "role"
}

variable "admin_role_values" {
  description = "SAML role values that should have admin access"
  type        = list(string)
  default     = ["Admin", "Administrator"]
}

variable "editor_role_values" {
  description = "SAML role values that should have editor access"
  type        = list(string)
  default     = ["Editor", "Developer"]
}

variable "viewer_role_values" {
  description = "SAML role values that should have viewer access"
  type        = list(string)
  default     = ["Viewer", "ReadOnly"]
}

variable "vpc_configuration" {
  description = "VPC configuration for Grafana workspace"
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "network_access_control" {
  description = "Network access control configuration"
  type = object({
    prefix_list_ids = list(string)
    vpce_ids        = list(string)
  })
  default = null
}

variable "authentication_providers" {
  description = "List of authentication providers for Grafana workspace"
  type        = list(string)
  default     = ["SAML"]
  validation {
    condition     = alltrue([
      for provider in var.authentication_providers :
      contains(["AWS_SSO", "SAML"], provider)
    ])
    error_message = "Authentication providers must be one of: AWS_SSO, SAML."
  }
}
