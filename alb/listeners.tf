resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.woznet_alb.arn
  port              = "80"
  protocol          = "HTTP"

  routing_http_response_access_control_allow_origin_header_value = "https://www.kinaida.net https://www.ourzoo.us"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Ourzoo"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.woznet_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn   = "arn:aws:acm:us-east-1:742629497219:certificate/4b568b47-1943-442d-abbe-e65b7ab5a78f"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"

  routing_http_response_access_control_allow_origin_header_value = "https://www.kinaida.net https://www.ourzoo.us"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Ourzoo"
      status_code  = "200"
    }
  }
}

