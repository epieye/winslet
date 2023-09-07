#################################################################################
##                                                                              #
## I could make a load-balancer module, work for internal/external alb/nlb/etc. #
## and flexible enough for different conditions host, path, source etc          #
##                                                                              #
#################################################################################
#
#resource "aws_lb" "woznet_alb" {
#  name                       = "woznet-alb"
#  internal                   = false
#  load_balancer_type         = "application"
#  security_groups            = [aws_security_group.woznet1-sg.id]
#  subnets                    = [aws_subnet.woznet_subnet_public_1a.id, aws_subnet.woznet_subnet_public_1b.id]
#
#  drop_invalid_header_fields = true
#  enable_deletion_protection = false
#
#  tags = {
#    Name = "woznet-alb"
#  }
#}
#
#resource "aws_lb_listener" "woznet_listener_http" {
#  load_balancer_arn = aws_lb.woznet_alb.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type = "fixed-response"
#
#    fixed_response {
#      content_type = "text/plain"
#      message_body = "Datascan LLC"
#      status_code  = "200"
#    }
#  }
#}
#
#resource "aws_lb_target_group" "woznet-http-tg" {
#  name        = "woznet-http-tg"
#  port        = 80
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_vpc.woznet_vpc1.id
#
#  health_check {
#    enabled = true
#    healthy_threshold = 2
#    protocol = "HTTP"
#    interval = 5
#    path = "/"
#    matcher = "200,403,404"
#    port = 80
#    timeout = 2
#    unhealthy_threshold = 2
#  }
#}
#
#resource "aws_lb_target_group_attachment" "woznet-http-tga1" {
#  target_group_arn = aws_lb_target_group.woznet-http-tg.arn
#  target_id        = aws_instance.esteban.private_ip
#  port             = 80
#  availability_zone = "all"
#}
#
#resource "aws_lb_target_group_attachment" "woznet-http-tga2" {
#  target_group_arn = aws_lb_target_group.woznet-http-tg.arn          
#  target_id        = aws_instance.michio.private_ip
#  port             = 80
#  availability_zone = "all"
#}
#
#resource "aws_lb_listener_rule" "woznet_http" {
#  listener_arn = aws_lb_listener.woznet_listener_http.arn
#  priority = 35
#
#  action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.woznet-http-tg.arn
#  }
#
#  condition {
#    source_ip {
#      values = ["172.125.57.137/32"] # Imperva is 
#    }
#  }
#
#  condition {
#    host_header {
#      values = ["www.kinaida.net"]
#    }
#  }
#}
#
#resource "aws_route53_record" "web_server" {
# zone_id = "Z07643963KV3I332WTGCB"
#  name    = "www.kinaida.net" # How do I add kinaida.net too?
#  type    = "CNAME"
#  ttl     = "60"
#  records = [aws_lb.woznet_alb.dns_name]
#}
#
