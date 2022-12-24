#
# ARGH!
# Also gets Error: Provider produced inconsistent final plan
# Is it just my account?
# Try it in lab qual
#
# Well, still might be the things I've commented out. Like the environment variables. 
#
#
#
#
#
## S3 Bucket
#
##module "devqa_wi_s3" {
##  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//s3"
##  source = "../../modules/s3"
##
##  policy = templatefile("${path.module}/policies/alb_s3_log.json",
##    {
##      elb_account_id = data.aws_elb_service_account.main.id,
##      account_id = data.aws_caller_identity.current.account_id,
##      prefix = "wi-ingress-lb",
##      bucket_name = "datascan-devqawi"
##    }
##  )
##
##  tags = merge(
##    module.configuration.tags,
##    {
##      Name = "datascan-devqawi"
##    }
##  )
##}
#
## Security Group
#
#module "devqa_wi_sec_group_alb_sg" {
#  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//security_group"
#  source = "../../modules/security_group/"
#  #vpc_id = module.ingress_vpc.vpc_id
#  vpc_id = "vpc-0a423d066b28fa405"
#
#  ingress = [{
#      from_port   = 80
#      to_port   = 80
#      protocol  = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    },
#    {
#      from_port   = 443
#      to_port   = 443
#      protocol  = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#  ]
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "devqawi ALB security group"
#    }
#  )
#}
#
## Load Balancer
#
#resource "aws_lb" "devqa_wi_alb" {
#  name               = "devqawi-alb"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [module.devqa_wi_sec_group_alb_sg.id]
#  #subnets            = module.ingress_vpc.public_subnet_ids
#  subnets            = [
#    "subnet-007a52bab4870315a",
#    "subnet-0424a4a48a04e6cca",
#    "subnet-0ca3aac94e7e5fa7b",
#    "subnet-027dc365f5b93a0da",
#  ]
#
#  enable_deletion_protection = true
#
#  #access_logs {
#  #  #bucket  = module.devqa_wi_s3.bucket_id
#  #  prefix  = "ingress-1"
#  #  enabled = true
#  #}
#
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "devqawi-alb"
#    }
#  )
#}
#
#
## HTTP resources
#resource "aws_lb_listener" "devqa_wi_listener_http" {
#  load_balancer_arn = aws_lb.devqa_wi_alb.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#   default_action {
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
### HTTPS resources
##data "aws_acm_certificate" "wild_wi_onedatascan_io" {
##  domain      = "*.wi.onedatascan.io"
##  types       = ["IMPORTED"]
##  most_recent = true
##}
#
##resource "aws_lb_listener" "devqa_wi_listener_https" {
##  load_balancer_arn = aws_lb.devqa_wi_alb.arn
##  port              = "443"
##  protocol          = "HTTPS"
##  certificate_arn   = data.aws_acm_certificate.wild_wi_onedatascan_io.arn
##  ssl_policy        = "ELBSecurityPolicy-2016-08"
##
##   default_action {
##    type = "fixed-response"
##
##    fixed_response {
##      content_type = "text/plain"
##      message_body = "Datascan LLC"
##      status_code  = "200"
##    }
##  }
##}
#
#module "devqa_wi_alb_updater" {
#    #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//lambda"
#    source = "../../modules/lambda"
#
#    description = "Keeps the ALB target groups updated automatically based on hostname"
#
#
#    environment = {
#      #ALB_ID = aws_lb.ingress_alb.id,
#      #ENDPOINTS = "devqawi-login-devqawiciax.sso.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com,devqawi-devqawimr01.wi.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com,devqawi-devqawimr01-das.wi.onedatascan.io:internal-a1249403ad9a943e4976045eee1dc3dc-1299789860.us-east-1.elb.amazonaws.com",
#      #VPC_ID = module.ingress_vpc.vpc_id,
#      #LISTENER_ARN = aws_lb_listener.front_end.arn
#      ALB_ID = ""
#      ENDPOINTS = ""
#      VPC_ID = ""
#      LISTENER_ARN = ""
#    }
#
#    lambda_source_dir = "${path.cwd}/lambdas/ec2_updater"
#    schedule_expression = "rate(1 minute)"
#    #iam_role_arn = aws_iam_role.iam_for_alb_updater_lambda.arn
#
#    tags = merge(
#    module.configuration.tags,
#    {
#      Name = "devqa-wi-alb-updater-1"
#    }
#  )
#}
