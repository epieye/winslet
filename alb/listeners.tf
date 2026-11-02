data "aws_acm_certificate" "kinaida" {
  domain      = "*.kinaida.net"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Change this so HTTP just redirects to HTTPS
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.woznet_alb.arn
  port              = "80"
  protocol          = "HTTP"

  #routing_http_response_access_control_allow_origin_header_value = "https://www.kinaida.net https://www.ourzoo.us"

  default_action {
    type = "redirect"
  
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.woznet_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn   = data.aws_acm_certificate.kinaida.id
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"

  #routing_http_response_access_control_allow_origin_header_value = "https://www.kinaida.net https://www.ourzoo.us"

  #default_action {
  #  type = "fixed-response"
  #
  #  fixed_response {
  #    content_type = "text/plain"
  #    message_body = "Ourzoo"
  #    status_code  = "200"
  #  }
  #}

  default_action {
    type = "authenticate-cognito"
    order = 1
  
    authenticate_cognito {
      user_pool_arn       = aws_cognito_user_pool.pool.arn
      user_pool_client_id = aws_cognito_user_pool_client.client.id
      user_pool_domain    = aws_cognito_user_pool_domain.main.domain
      
      # Options: code or implicit
      session_cookie_name      = "AWSELBAuthSessionCookie"
      session_timeout          = 3600
      scope                    = "openid"
      on_unauthenticated_request = "authenticate" # Options: authenticate, allow, deny
    }
  }

  # 2. Sequential Forward Action
  default_action {
    type             = "forward"
    order            = 2
    target_group_arn = aws_lb_target_group.woznet-tg.arn
  }
}

