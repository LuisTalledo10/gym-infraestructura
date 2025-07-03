output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.gym_user_pool.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.gym_user_pool.arn
}

output "user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.gym_user_pool.endpoint
}

output "user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.gym_client.id
}

output "user_pool_client_secret" {
  description = "Secret of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.gym_client.client_secret
  sensitive   = true
}

output "user_pool_domain" {
  description = "Domain of the Cognito User Pool"
  value       = aws_cognito_user_pool_domain.gym_domain.domain
}

output "user_pool_domain_aws_account_id" {
  description = "AWS account ID of the Cognito User Pool Domain"
  value       = aws_cognito_user_pool_domain.gym_domain.aws_account_id
}

output "user_pool_domain_cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN of the Cognito User Pool Domain"
  value       = aws_cognito_user_pool_domain.gym_domain.cloudfront_distribution_arn
}

output "identity_pool_id" {
  description = "ID of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.gym_identity_pool.id
}

output "identity_pool_arn" {
  description = "ARN of the Cognito Identity Pool"
  value       = aws_cognito_identity_pool.gym_identity_pool.arn
}

output "authenticated_role_arn" {
  description = "ARN of the authenticated IAM role"
  value       = aws_iam_role.authenticated.arn
}

# Cognito Configuration for frontend applications
output "cognito_config" {
  description = "Cognito configuration object for frontend applications"
  value = {
    region          = data.aws_region.current.name
    userPoolId      = aws_cognito_user_pool.gym_user_pool.id
    userPoolWebClientId = aws_cognito_user_pool_client.gym_client.id
    identityPoolId  = aws_cognito_identity_pool.gym_identity_pool.id
    domain          = aws_cognito_user_pool_domain.gym_domain.domain
  }
}

# Groups
output "admin_group_name" {
  description = "Name of the admin group"
  value       = aws_cognito_user_group.gym_admins.name
}

output "trainer_group_name" {
  description = "Name of the trainer group"
  value       = aws_cognito_user_group.gym_trainers.name
}

output "member_group_name" {
  description = "Name of the member group"
  value       = aws_cognito_user_group.gym_members.name
}

# Data source for current AWS region
data "aws_region" "current" {}
