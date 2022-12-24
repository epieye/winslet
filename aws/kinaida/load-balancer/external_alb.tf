module "sec_group_ex_alb_sg" {
  source = "../../modules/security_group/"
  vpc_id = module.kinaida-lbnet.vpc_id

  ingress = [
    {
      from_port   = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = { Name = "Woznet External ALB security group" }
}

# Create ALB
resource "aws_lb" "ex_alb" {
  name               = "ex-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.kinaida-lbnet.public_subnet_ids
  security_groups    = [module.sec_group_ex_alb_sg.id]
  tags = {
    Name = "ex_alb"
  }

  #access_logs {
  #  bucket  = "ourzoo.us"
  #  enabled = true
  #}
}

# HTTP Listener
resource "aws_lb_listener" "ex_alb_listener_http" {
  load_balancer_arn = aws_lb.ex_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Ourzoo"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.ex_alb_listener_http.arn
  priority = 10

  #action {
  #  type = "forward"
  #  forward {
  #    target_group {
  #      arn = aws_lb_target_group.ex_alb_tg.arn
  #      weight = 60
  #    }
  #    target_group {
  #      arn = aws_lb_target_group.ex_alb_tg2.arn
  #      weight = 40
  #    }
  #  }
  #}

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ex_alb_tg.arn
  }

  # why can't I just forward anything 
  condition {
    host_header {
      values = ["test.kinaida.net"]
    }
  }
}

# Create ALB target group that forwards traffic to EC2 instances
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
resource "aws_lb_target_group" "ex_alb_tg" {
    name         = "ex-alb-tg"
    port         = 80
    protocol     = "HTTP"
    vpc_id       = module.kinaida-lbnet.vpc_id
    target_type  = "ip"

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 30
    path = "/"
    port = 80
    timeout = 5
    unhealthy_threshold = 3
  }

}

resource "aws_lb_target_group_attachment" "ex_alb_tg_attachment" {
    target_group_arn = aws_lb_target_group.ex_alb_tg.arn
    availability_zone = "all"
    target_id  = "192.168.9.175" # one of the internal load balancer addresses
    port       = 80
}

#resource "aws_lb_target_group" "ex_alb_tg2" {
#    name         = "ex-alb-tg2"
#    port         = 80
#    protocol     = "HTTP"
#    vpc_id       = module.kinaida-lbnet.vpc_id
#    target_type  = "ip"
#}

#resource "aws_lb_target_group_attachment" "ex_alb_tg_attachment2" {
#    target_group_arn = aws_lb_target_group.ex_alb_tg2.arn
#    availability_zone = "all"
#    target_id  = "192.168.9.236"
#    port       = 80
#}


output "external_arn" {
  value = aws_lb.ex_alb.arn
}

output "external_dns_name" {
  value = aws_lb.ex_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.ex_alb_tg.arn
}
