resource "aws_lb_listener_rule" "woznet_http" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority = 30

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.woznet-http-tg.arn
  }

  condition {
    source_ip {
      values = ["172.125.57.137/32"] # Only from home.ourzoo.us
    }
  }

  condition {
    host_header {
      values = ["www.kinaida.net"]
    }
  }
}

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

resource "aws_lb_listener_rule" "woznet_https" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority = 35

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.woznet-http-tg.arn
  }

  condition {
    source_ip {
      values = ["172.125.57.137/32"] # Only from home.ourzoo.us
    }
  }

  condition {
    host_header {
      values = ["www.kinaida.net"]
    }
  }
}

