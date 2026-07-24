#


resource "aws_globalaccelerator_accelerator" "ourzoo" {
  name            = "Ourzoo-GA"
  ip_address_type = "IPV4"
  ip_addresses    = ["1.2.3.4"] # ?
  enabled         = true

  attributes {
    flow_logs_enabled   = false # true
    #flow_logs_s3_bucket = "example-bucket"
    #flow_logs_s3_prefix = "flow-logs/"
  }
}

resource "aws_globalaccelerator_listener" "ourzoo" {
  accelerator_arn = aws_globalaccelerator_accelerator.ourzoo.arn
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}


