#
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint
#
#

resource "aws_ec2_client_vpn_endpoint" "ourzoo" {
  description            = "ourzoo-client-vpn"
  server_certificate_arn = aws_acm_certificate.cert.arn
  client_cidr_block      = "10.0.0.0/16"                           # The point is I want it on the same network as amos etc

  vpc_id = ""

  authentication_options {
    type                       = "certificate-authentication"      #<-?
    root_certificate_chain_arn = aws_acm_certificate.root_cert.arn #<-?
  }

  split_tunnel = true

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name      #?
    cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name     #?
  }
}
