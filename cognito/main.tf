# Cognito User Pool for gym user authentication
resource "aws_cognito_user_pool" "gym_user_pool" {
  name = var.user_pool_name

  alias_attributes           = ["email", "preferred_username"]
  auto_verified_attributes   = ["email"]
  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Schema attributes
  schema {
    attribute_data_type = "String"
    name               = "email"
    required           = true
    mutable           = true
  }

  schema {
    attribute_data_type = "String"
    name               = "name"
    required           = true
    mutable           = true
  }

  schema {
    attribute_data_type = "String"
    name               = "phone_number"
    required           = false
    mutable           = true
  }

  # Account recovery setting
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # User pool add-ons
  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }

  # Verification message templates
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Gym Management - Verificación de cuenta"
    email_message        = "Tu código de verificación es {####}"
  }

  tags = {
    Name        = "gym-user-pool"
    Environment = var.environment
    Project     = "gym-management"
  }
}

# User Pool Client
resource "aws_cognito_user_pool_client" "gym_client" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.gym_user_pool.id

  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls

  # Supported identity providers
  supported_identity_providers = ["COGNITO"]

  # Token validity
  access_token_validity  = 1  # 1 hour
  id_token_validity     = 1  # 1 hour
  refresh_token_validity = 30 # 30 days

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  # Prevent user existence errors
  prevent_user_existence_errors = "ENABLED"

  # Explicit auth flows
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# User Pool Domain
resource "aws_cognito_user_pool_domain" "gym_domain" {
  domain       = var.domain_name
  user_pool_id = aws_cognito_user_pool.gym_user_pool.id
}

# Identity Pool
resource "aws_cognito_identity_pool" "gym_identity_pool" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.gym_client.id
    provider_name           = aws_cognito_user_pool.gym_user_pool.endpoint
    server_side_token_check = false
  }

  tags = {
    Name        = "gym-identity-pool"
    Environment = var.environment
    Project     = "gym-management"
  }
}

# IAM Role for authenticated users
resource "aws_iam_role" "authenticated" {
  name = "cognito_authenticated_gym"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.gym_identity_pool.id
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })
}

# IAM Policy for authenticated users
resource "aws_iam_role_policy" "authenticated" {
  name = "authenticated_policy"
  role = aws_iam_role.authenticated.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-sync:*",
          "cognito-identity:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "execute-api:Invoke"
        ]
        Resource = var.api_gateway_arn != "" ? "${var.api_gateway_arn}/*" : "*"
      }
    ]
  })
}

# Identity Pool Role Attachment
resource "aws_cognito_identity_pool_roles_attachment" "gym_attachment" {
  identity_pool_id = aws_cognito_identity_pool.gym_identity_pool.id

  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}

# User Pool Groups
resource "aws_cognito_user_group" "gym_admins" {
  name         = "gym-admins"
  user_pool_id = aws_cognito_user_pool.gym_user_pool.id
  description  = "Gym administrators with full access"
  precedence   = 1
}

resource "aws_cognito_user_group" "gym_trainers" {
  name         = "gym-trainers"
  user_pool_id = aws_cognito_user_pool.gym_user_pool.id
  description  = "Gym trainers with limited access"
  precedence   = 2
}

resource "aws_cognito_user_group" "gym_members" {
  name         = "gym-members"
  user_pool_id = aws_cognito_user_pool.gym_user_pool.id
  description  = "Gym members with basic access"
  precedence   = 3
}
