resource "aws_lb_target_group" "woznet-http-tg" {
  name        = "woznet-http-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.woznet_vpc.id

  health_check {
    enabled = true
    healthy_threshold = 2
    protocol = "HTTP"
    interval = 5
    path = "/"
    matcher = "200,403,404"
    port = 80
    timeout = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "woznet-http-tga2" {
  target_group_arn = aws_lb_target_group.woznet-http-tg.arn          
  target_id        = aws_instance.michio.private_ip
  port             = 80
  availability_zone = "us-east-1a" # cannot be all when it's in the same VPC
}

resource "aws_lb_target_group_attachment" "woznet-http-tga1" {
  target_group_arn = aws_lb_target_group.woznet-http-tg.arn
  target_id        = aws_instance.esteban.private_ip
  port             = 80
  availability_zone = "us-east-1b" # cannot be all when it's in the same VPC
}

