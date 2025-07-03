provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"
}

module "rds" {
  source             = "./rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
}

module "s3" {
  source = "./s3"
}

module "api_gateway" {
  source = "./api_gateway"
}

module "lambda" {
  source = "./lambda"
  
  # Variables para conectar con otros módulos
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_endpoint        = module.rds.db_endpoint
  s3_bucket_name     = module.s3.bucket_name
}

module "iam" {
  source = "./iam"
}

# Comentado temporalmente hasta que se despliegue el resto de la infraestructura
module "monitoring" {
  source = "./monitoring"
  
  # Variables para el dashboard
  lambda_user_function_name    = "gym-user-management"
  lambda_booking_function_name = "gym-booking-system" 
  lambda_payment_function_name = "gym-payment-processor"
  rds_instance_identifier      = module.rds.db_instance_identifier
  api_gateway_name            = "gym-api"
  s3_bucket_name              = module.s3.bucket_name
  sns_topic_arn               = module.iam.sns_topic_arn
  region                      = var.region
}


