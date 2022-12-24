module "sec_group_in_alb_sg" {
  source = "../../modules/security_group/"
  vpc_id = module.lbnet.vpc_id

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

  tags = { Name = "Woznet ALB security group" }
}

# Create ALB
resource "aws_lb" "in_alb" {
  name               = "in-alb"
  internal           = true 
  load_balancer_type = "application"
  subnets            = module.lbnet.public_subnet_ids
  security_groups    = [module.sec_group_in_alb_sg.id]
  tags = {
    Name = "in_alb"
  }

  # Read and understand https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html <- wait it is classic?
  access_logs {
    bucket  = "ourzoo.us"
    enabled = true

    policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::ourzoo", "arn:aws:s3:::ourzoo/*", "arn:aws:s3:::ourzoo/AWSLogs", "arn:aws:s3:::ourzoo/AWSLogs/*"],
      "Principal": {"
        "AWS": [
          "742629497219"
        ]
      }
    }
  ]
}
POLICY
  }
}

# HTTP Listener
resource "aws_lb_listener" "in_alb_listener_http" {
  load_balancer_arn = aws_lb.in_alb.arn
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

resource "aws_lb_listener_rule" "http_rule1" {
  listener_arn = aws_lb_listener.in_alb_listener_http.arn
  priority = 10

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.in_alb_tg.arn
  }

  condition {
    host_header {
      values = ["test.kinaida.net"]
    }
  }
}


# Create ALB target group that forwards traffic to EC2 instances
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
resource "aws_lb_target_group" "in_alb_tg" {
    name         = "in-alb-tg"
    port         = 80
    protocol     = "HTTP"
    vpc_id       = module.lbnet.vpc_id
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

resource "aws_lb_target_group_attachment" "in_alb_tg_attachment" {
    target_group_arn = aws_lb_target_group.in_alb_tg.arn
    target_id        = module.lbnet_ec2_1.module_ec2.private_ip
    port             = 80
}

output "internal_arn" {
  value = aws_lb.in_alb.arn
}

output "internal_dns_name" {
  value = aws_lb.in_alb.dns_name
}

