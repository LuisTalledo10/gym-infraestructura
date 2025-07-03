variable "vpc_id" {
  description = "ID de la VPC donde se creará el RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subredes privadas para el RDS"
  type        = list(string)
}

variable "db_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña del usuario administrador"
  type        = string
}