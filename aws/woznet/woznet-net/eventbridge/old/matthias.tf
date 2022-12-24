#
#Argh!
#
#I just want to test one thing ffs.
#
#
#
#/* Create and keps ALB up to date based on IPs resolved via DNS using Lambda function*/
#data "aws_elb_service_account" "main" {}
#
##module "ingress_vpc" {
##  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//network"
##  source = "../../modules/network"
##
##  base_cidr_block = "10.245.0.0/22"
##  internet_gateway = true
##
##
##  custom_private_routes = [
##    {
##      destination_cidr_block = "10.0.0.0/8"
##      transit_gateway_id = module.transit_gateway.id
##    }
##  ]
##
##  custom_public_routes = [
##    {
##      destination_cidr_block = "10.0.0.0/8"
##      transit_gateway_id = module.transit_gateway.id
##    }
##  ]
##
##  tags = merge(
##    module.configuration.tags,
##    {
##      Name = "nsi-ingress"
##    }
##  )
##}
##
##module "nsi_s3" {
##  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//s3"
##  source = "../../modules/s3"
##
##  policy = templatefile("${path.module}/policies/alb_s3_log.json",
##    {
##      elb_account_id = data.aws_elb_service_account.main.id,
##      account_id = data.aws_caller_identity.current.account_id,
##      prefix = "ingress-1",
##      bucket_name = "datascan-nsi"
##    }
##  )
##
##  tags = merge(
##    module.configuration.tags,
##    {
##      Name = "datascan-nsi"
##    }
##  )
##}
#
#module "ingress_sec_group" {
#  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//security_group"
#  source = "../../modules/security_group"
#
#  vpc_id = module.ingress_vpc.vpc_id
#
#  ingress = [
#    {
#      to_port = 80
#      from_port = 0
#      protocol = "tcp"
#      cidr_blocks = ["0.0.0.0/0"]
#    },
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
#      Name = "Ingress Security Group"
#    }
#  )
#}
#
#resource "aws_lb" "ingress_alb" {
#  name               = "Ingress-1"
#  internal           = false
#  load_balancer_type = "application"
#  security_groups    = [module.ingress_sec_group.id]
#  subnets            = module.ingress_vpc.public_subnet_ids
#
#  enable_deletion_protection = true
#
#  access_logs {
#    bucket  = module.nsi_s3.bucket_id
#    prefix  = "ingress-1"
#    enabled = true
#  }
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "Ingress-1"
#    }
#  )
#}
#
#resource "aws_lb_listener" "front_end" {
#  load_balancer_arn = aws_lb.ingress_alb.arn
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
#resource "aws_iam_role" "iam_for_alb_updater_lambda" {
#  name = "iam_for_alb_updater"
#
#  inline_policy {
#    name = "ec2_and_elb"
#    policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Sid": "EC2",
#            "Effect": "Allow",
#            "Action": [
#                "ec2:*"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Sid": "ELB",
#            "Effect": "Allow",
#            "Action": [
#                "elasticloadbalancing:*"
#            ],
#            "Resource": "*"
#        }
#    ]
#}
#EOF
#  }
#
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}
#
#module "alb_updater" {
#    #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//lambda"
#    source = "../../modules/lambda"
#
#    description = "Keeps the ALB target groups updated automatically based on hostname"
#
#    /*
#      ENDPOINTS, comma separated following below format:
#
#      app1.onedatascan.com:google.com
#
#      Creates a rule that sends any traffic for app1.onedatascan.com 
#        to the IP addresses behind google.com
#    */
#
#    environment = {
#      ALB_ID = aws_lb.ingress_alb.id,
#      ENDPOINTS = "app1.onedatascan.com:fake-internal-ip.hashology.io",
#      VPC_ID = module.ingress_vpc.vpc_id,
#      LISTENER_ARN = aws_lb_listener.front_end.arn
#    }
#
#    lambda_source_dir = "${path.cwd}/lambdas/alb_updater"
#    schedule_expression = "rate(1 minute)"
#    iam_role_arn = aws_iam_role.iam_for_alb_updater_lambda.arn
#
#    tags = merge(
#    module.configuration.tags,
#    {
#      Name = "alb-updater-1"
#    }
#  )
#}
