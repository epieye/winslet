# Testing with self-signed cert. This will be replaced with a store-bought cert in due course.
resource "tls_private_key" "warren_temp_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "warren_temp_cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.warren_temp_key.private_key_pem

  subject {
    common_name  = "onedatascan.io"
    organization = "Datascan"
  }

  validity_period_hours = 12

  allowed_uses = [
    "any_extended"
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.warren_temp_key.private_key_pem
  certificate_body = tls_self_signed_cert.warren_temp_cert.cert_pem
}

## Exactly the same as the Ingress LB SG, but create an identical one in case one or the other needs to change or is deleted. 
#module "woznet  palo_vpn_sg" {
#  source = "../modules/security_group"
#
#  vpc_id = module.woznet.vpc_id
#
#  ingress = [
#    {
#      to_port = 443
#      from_port = 0
#      protocol = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "Palo-VPN Security Group"
#    }
#  )
#}

# The ALB itself. I still need to specify the target group.
resource "aws_lb" "vpn_alb" {
  name               = "vpn-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.woznet_sg.id]
  subnets            = module.woznet.public_subnet_ids

  enable_deletion_protection = false

  #access_logs {
  #  bucket  = module.nsi_s3.bucket_id
  #  prefix  = "vpn-lb"
  #  enabled = true
  #}

  tags = merge(
    module.configuration.tags,
    {
      Name = "vpn-alb"
    }
  )
}

# Listener on the LB that users connect to.
resource "aws_lb_listener" "vpn_front_end" {
  load_balancer_arn = aws_lb.vpn_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  # error creating ELBv2 Listener (arn:aws:elasticloadbalancing:us-east-1:961552672486:loadbalancer/app/vpn-alb/bcb2ad9e9043ccb8): ValidationError: A certificate must be specified for HTTPS listeners
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Gotcha"
      status_code  = "200"
    }
  }
}

# Matthias' ingress LB also has an updater with an associated iam role.
# But VPN portal is configured on the Palo, not via terraform. 

# Do I need an additional cidr / subnets for this alb? I can probably use the exisitng ones for this example. 
