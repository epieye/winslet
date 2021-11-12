# Locate the server and client certificates
data "aws_acm_certificate" "associate_vpn_server_keypair" {
  domain   = "home.ourzoo.us"
  statuses = ["ISSUED"]
}


data "aws_acm_certificate" "associate_vpn_client_keypair" {
  domain   = "home.ourzoo.us"
  statuses = ["ISSUED"]
}


resource "aws_cloudwatch_log_group" "associate_vpn_cw_loggroup" {
  name                 = "associate_vpn_loggroup"
  retention_in_days    = 14

  tags = merge(
    module.configuration.tags,
    {
      Name = "poc-associate-vpn-loggroup"
      Environment = "POC"
      Application = "associate_vpn"
    }
  )
}


resource "aws_cloudwatch_log_stream" "associate_vpn_cw_logstream" {
  name           = "poc-associate-vpn-logstream"
  log_group_name = aws_cloudwatch_log_group.associate_vpn_cw_loggroup.name
}





resource "aws_iam_saml_provider" "aws-client-vpn" {
  name                   = "aws-client-vpn"
  saml_metadata_document = file("aws-client-vpn.xml")
}

resource "aws_iam_saml_provider" "aws-client-vpn-self-service" {
  name                   = "aws-client-vpn-self-service"
  saml_metadata_document = file("aws-client-vpn-self-service.xml")
}


## Example from terraform site
#resource "aws_ec2_client_vpn_endpoint" "example" {
#  description            = "terraform-clientvpn-example"
#  server_certificate_arn = aws_acm_certificate.cert.arn
#  client_cidr_block      = "10.0.0.0/16"
#
#  authentication_options {
#    type                       = "certificate-authentication"
#    root_certificate_chain_arn = aws_acm_certificate.root_cert.arn
#  }
#
#  connection_log_options {
#    enabled               = true
#    cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
#    cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
#  }
#}





resource "aws_ec2_client_vpn_endpoint" "associate_vpn" {
  description            = "associate_vpn"
  server_certificate_arn = data.aws_acm_certificate.associate_vpn_server_keypair.arn
  #client_cidr_block      = "10.245.128.0/22"
  client_cidr_block      = "10.0.0.0/22"
  transport_protocol     = "tcp"
  split_tunnel           = true
  self_service_portal    = "enabled"

  # this is my cert that I created in ACM. I don't know how this is supposed to work. Is this the client authentication for the vpn?
  # no, I don't think so, just cert. Surely we need something telling the vpn to auth against ad (azure ad or intermediate)
  #authentication_options {
  #  type                       = "certificate-authentication"
  #  root_certificate_chain_arn = "arn:aws:acm:us-east-1:742629497219:certificate/e8460105-aef4-4438-b1a5-df5fc7bb29d6"
  #}

  authentication_options {
    type                           = "federated-authentication" 
    saml_provider_arn              = aws_iam_saml_provider.aws-client-vpn.arn
    self_service_saml_provider_arn = aws_iam_saml_provider.aws-client-vpn-self-service.arn
  }


  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.associate_vpn_cw_loggroup.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.associate_vpn_cw_logstream.name
  }

#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "poc-datascan-associate-vpn"
#      Environment = "POC"
#      Application = "associate_vpn"
#    }
#  )

}

# le0 sn0 ?
resource "aws_ec2_client_vpn_network_association" "associate_vpn_le0_sn0" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  subnet_id = aws_subnet.private_subnet1[0].id
}

# le0 sn1 - why two ? Is this just redundancy?
resource "aws_ec2_client_vpn_network_association" "associate_vpn_le0_sn1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  subnet_id  = aws_subnet.private_subnet2[0].id
}


# Additional routes
resource "aws_ec2_client_vpn_route" "associate_vpn_le0_sn0_route0" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  #destination_cidr_block = "192.168.3.0/25"
  destination_cidr_block = "10.1.0.0/22" 
  #destination_cidr_block = "10.249.6.0/24" <- OK so 10.245.128.0/22 is not a supernet but my 10.1.0.0/22 is (?)
  target_vpc_subnet_id   = aws_subnet.private_subnet1[0].id
}


resource "aws_ec2_client_vpn_route" "associate_vpn_le0_sn1_route0" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  #destination_cidr_block = "192.168.3.128/25"
  destination_cidr_block = "10.2.0.0/22"
  #destination_cidr_block = "10.249.6.0/24"
  target_vpc_subnet_id   = aws_subnet.private_subnet2[0].id
}


resource "aws_ec2_client_vpn_authorization_rule" "associate_vpn_auth_aws_network" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  target_network_cidr    = "10.0.0.0/8"
  authorize_all_groups   = true
}


output "associate_vpn_fqdn" {
  value = aws_ec2_client_vpn_endpoint.associate_vpn.dns_name
}
