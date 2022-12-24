# Locate the server and client certificates
data "aws_acm_certificate" "associate_vpn_server_keypair" {
  domain   = "home.ourzoo.us"
  statuses = ["ISSUED"]
}

## Isn't this exactly the same as above?
#data "aws_acm_certificate" "associate_vpn_client_keypair" {
#  domain   = "home.ourzoo.us"
#  statuses = ["ISSUED"]
#}

## I should have logging, but it's not essential
#resource "aws_cloudwatch_log_group" "associate_vpn_cw_loggroup" {
#  name                 = "associate_vpn_loggroup"
#  retention_in_days    = 14
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "poc-associate-vpn-loggroup"
#      Environment = "POC"
#      Application = "associate_vpn"
#    }
#  )
#}


#resource "aws_cloudwatch_log_stream" "associate_vpn_cw_logstream" {
#  name           = "poc-associate-vpn-logstream"
#  log_group_name = aws_cloudwatch_log_group.associate_vpn_cw_loggroup.name
#}





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
  client_cidr_block      = "192.168.8.0/22"
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
    enabled               = false
#    enabled               = true
#    cloudwatch_log_group  = aws_cloudwatch_log_group.associate_vpn_cw_loggroup.name
#    cloudwatch_log_stream = aws_cloudwatch_log_stream.associate_vpn_cw_logstream.name
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
  subnet_id = data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[0]
}

# le0 sn1 - why two ? Is this just redundancy?
resource "aws_ec2_client_vpn_network_association" "associate_vpn_le0_sn1" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  subnet_id = data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[1]
  
}


# Additional routes
resource "aws_ec2_client_vpn_route" "associate_vpn_le0_sn0_route0" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  destination_cidr_block = "192.168.4.0/22"
  target_vpc_subnet_id   = data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[0]
}


resource "aws_ec2_client_vpn_route" "associate_vpn_le0_sn1_route0" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  destination_cidr_block = "192.168.4.0/22"
  target_vpc_subnet_id   = data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[1]
}


resource "aws_ec2_client_vpn_authorization_rule" "associate_vpn_auth_aws_network" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.associate_vpn.id
  target_network_cidr    = "192.168.4.0/22" 
  authorize_all_groups   = true
}

#192.168.0.0/16 
#192.168.128.0/17 
#192.168.192.0/18
#192.168.224.0/19
#192.168.240.0/20
#192.168.248.0/21
#192.168.252.0/22
#192.168.254.0/23
#192.168.255.0/24
#
#
#192.168.0.0/24
#192.168.1.0/24 AT&T
#192.168.2.0/24 Comcast
#192.168.3.0/24 -> 192.168.0.0/22  - home
#                  192.168.4.0/22  - aws        
#                  192.168.8.0/22  - vpn
#                  192.168.12.0/22 - azure
#                  192.168.16.0/22 - gcs
#ooh I could also have a site-to-site vpn between the clouds. nice. 

# aws ec2 describe-client-vpn-endpoints
output "Self-service-portal" {
  value = aws_ec2_client_vpn_endpoint.associate_vpn
}

#output "debug" {
#  value = data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids
#}
