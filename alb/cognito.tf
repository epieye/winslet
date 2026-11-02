resource "aws_cognito_user_pool" "pool" {
  name = "alb-auth-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "kinaidanet" # Must be unique globally within the AWS region
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "alb-auth-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret     = true
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["openid", "profile", "email"]
  
  # The explicit callback endpoint handled automatically by the ALB layer
  callback_urls = ["https://www.kinaida.net/oauth2/idpresponse"]
  
  supported_identity_providers = ["COGNITO"]
  
  allowed_oauth_flows_user_pool_client = true
}

# Create a User inside the Pool
resource "aws_cognito_user" "example_user" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username     = "warren@ourzoo.us"

  # Define profile attributes
  attributes = {
    email          = "warren@ourzoo.us"
    email_verified = "true"
  }

  # Set a temporary password (forces change on first login)
  temporary_password = "SecurePassword123!"

  # Suppress the welcome email if you plan to share credentials manually
  #message_action = "SUPPRESS" 
}
