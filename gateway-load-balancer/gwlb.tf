

resource "aws_lb" "gateway_lb" {
  name                             = "woznet-gwlb"
  load_balancer_type               = "gateway"
  subnets                          = [aws_subnet.woznet_subnet_public_1a.id, aws_subnet.woznet_subnet_public_1b.id]
  enable_cross_zone_load_balancing = true
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "woznet-gwlb"
  }
}

resource "aws_lb_target_group" "gwlb_tg" {
  name        = "inspect-tg"
  protocol    = "GENEVE"
  target_type = "instance"
  port        = "6081"
  vpc_id      = aws_vpc.woznet_ingress_vpc.id
  health_check {
    port     = "443"
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gateway_lb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_tg.arn
  }
}

