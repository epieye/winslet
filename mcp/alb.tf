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

resource "aws_lb_target_group" "itops_target_group" {
  name        = "mcp-gateway"
  protocol    = "HTTPS"
  target_type = "lambda"
  vpc_id      = local.ingress_vpc.vpc_id

  # Does health check work for Lambda?
  #health_check {
  #  enabled = false       # Was true
  #  healthy_threshold = 2 # Min 2, was 3
  #  protocol = "HTTPS"
  #  interval = 300        # Max 300, was 30
  #  path = "/"
  #  matcher = "200,403,404"
  #  timeout = 5
  #  unhealthy_threshold = 3
  #}
}

resource aws_lambda_permission lambda_from_alb {
  statement_id = "AllowExecutionFromALB"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mcp_server_function.function_name
  principal = "elasticloadbalancing.amazonaws.com"
  source_arn = aws_lb_target_group.itops_target_group.arn
}

resource "aws_lb_target_group_attachment" "itops_target_group_attachment" {
  target_group_arn = aws_lb_target_group.itops_target_group.arn
  target_id        = data.terraform_remote_state.chatops.outputs.onboarding_arn
  depends_on       = [ aws_lambda_permission.lambda_from_alb ]
}

resource "aws_lb_listener_rule" "itops_listener_rule" {
  listener_arn = aws_lambda_function.mcp_server_function.arn
  priority = 20

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.itops_target_group.arn
  }

  condition {
    host_header {
      values = ["mcp.kinaida.net"]
    }
  }
}

resource "aws_route53_record" "mcp" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "mcp.kinaida.net"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.woznet_alb.dns_name]
}

