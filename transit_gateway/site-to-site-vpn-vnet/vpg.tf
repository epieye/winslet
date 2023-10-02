resource "aws_vpn_gateway" "vpn_gw" {
  #vpc_id = aws_vpc.ourzoo.id
  # use one of the vpcs created in transit-gateway.
  vpc_id = data.terraform_remote_state.transit_gateway.outputs.woznet1_vpc_id

  #amazon_side_asn   = var.virtual_private_gateways_amazon_side_asn
  # I assume the default is the Amazon default ASN.

  #availability_zone = var.virtual_private_gateways_availability_zone

  tags = {
    Name = "ourzoo-vpngw"
  }
}
