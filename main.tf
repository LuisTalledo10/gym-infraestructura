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

module "cognito" {
  source = "./cognito"
  
  user_pool_name      = "gym-user-pool"
  client_name         = "gym-web-client"
  domain_name         = "gym-auth-${random_string.domain_suffix.result}"
  identity_pool_name  = "gym-identity-pool"
  callback_urls       = ["https://${module.cloudfront.cloudfront_domain_name}/callback"]
  logout_urls         = ["https://${module.cloudfront.cloudfront_domain_name}/logout"]
  environment         = var.environment
  api_gateway_arn     = module.api_gateway.api_gateway_arn
}

module "cloudfront" {
  source = "./cloudfront"
  
  api_gateway_domain_name = module.api_gateway.api_gateway_domain_name
  s3_bucket_domain_name   = module.s3.bucket_domain_name
  environment             = var.environment
}

# Random string for unique domain names
resource "random_string" "domain_suffix" {
  length  = 8
  special = false
  upper   = false
}


