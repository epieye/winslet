resource "aws_lb" "woznet_alb" {
  name                       = "woznet-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.woznet-public-sg.id]
  subnets                    = [aws_subnet.woznet_subnet_public_1a.id, aws_subnet.woznet_subnet_public_1b.id]

  drop_invalid_header_fields = true
  enable_deletion_protection = false

  tags = {
    Name = "woznet-alb"
  }
}

