resource "aws_globalaccelerator_accelerator" "example" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "example" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "example" {
  listener_arn = aws_globalaccelerator_listener.example.id

  endpoint_configuration {
    endpoint_id = aws_lb.in_alb.arn
    weight      = 100
    client_ip_preservation_enabled = true
  }
}

output "globalaccelerator" {
  value = aws_globalaccelerator_accelerator.example
}
