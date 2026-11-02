#resource "aws_lb_listener_rule" "woznet_esteban" {
#  listener_arn = aws_lb_listener.http_listener.arn
#  priority = 10
#
#  #forward HTTP to HTTPS
#  action {
#    type = "redirect"
#  
#    redirect {
#      protocol    = "HTTPS"
#      port        = "443"
#      status_code = "HTTP_301"
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["*.kinaida.net"]
#    }
#  }
#}

#resource "aws_lb_listener_rule" "woznet_fixed" {
#  listener_arn = aws_lb_listener.http_listener.arn
#  priority = 35
#
#  action {
#    type = "fixed-response"
#
#    fixed_response {
#      content_type = "text/html"
#      message_body = "Nope."
#      status_code  = "200"
#    }
#
#  }
#
#  condition {
#    host_header {
#      values = ["ginseng.kinaida.net"]
#    }
#  }
#}
#
#resource "aws_lb_listener_rule" "woznet_michio" {
#  listener_arn = aws_lb_listener.http_listener.arn
#  priority = 40
#
#  action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.woznet-tg.arn
#  }
#
#  condition {
#    source_ip {
#      values = ["172.125.57.137/32"] # Only from home.ourzoo.us
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["www.kinaida.net"]
#    }
#  }
#}


## Only job for HTTP listener is to redirect to HTTPS. I think it will only forward if downstream is HTTPS too.
#resource "aws_lb_listener_rule" "woznet_http" {
#  listener_arn = aws_lb_listener.http_listener.arn
#  priority     = 30
#
#  action {
#    type = "redirect"
#
#    redirect {
#      protocol    = "HTTPS"
#      port        = "443"
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["www.kinaida.net"]
#    }
#  }
#}


resource "aws_lb_listener_rule" "woznet_ginseng" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority = 30

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.woznet-tg.arn
  }
  
  condition {
    host_header {
      values = ["ginseng.kinaida.net"]
    }
  }
  
  condition {
    path_pattern {
      values = ["*.txt"]
    }
  }
}


resource "aws_lb_listener_rule" "woznet_fixed" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority = 35

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "Nope."
      status_code  = "404"
    }

  }

  condition {
    host_header {
      values = ["ginseng.kinaida.net"]
    }
  }
}

resource "aws_lb_listener_rule" "woznet_www" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority = 40

  action {
    type  = "authenticate-cognito"
    order = 1

    authenticate_cognito {
      user_pool_arn       = aws_cognito_user_pool.pool.arn
      user_pool_client_id = aws_cognito_user_pool_client.client.id
      user_pool_domain    = aws_cognito_user_pool_domain.main.domain
      session_cookie_name = "AWSELBAuthSessionCookie"
      session_timeout     = 3600
      scope               = "openid"
      on_unauthenticated_request = "authenticate"
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.woznet-tg.arn
  }

  condition {
    host_header {
      values = ["www.kinaida.net"]
    }
  }
}

