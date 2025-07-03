variable "vpc_id" {
  description = "ID de la VPC donde se desplegará Lambda"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subredes privadas para Lambda"
  type        = list(string)
  default     = []
}

variable "db_endpoint" {
  description = "Endpoint de la base de datos RDS"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Nombre del bucket S3 para almacenamiento"
  type        = string
  default     = "default-bucket"
}

variable "stripe_secret_key" {
  description = "Clave secreta de Stripe para pagos"
  type        = string
  sensitive   = true
  default     = "sk_test_default"
}
