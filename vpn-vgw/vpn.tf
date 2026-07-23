#
#
#
#
#

resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.ToOurzoo.id
  vpn_gateway_id      = aws_vpn_gateway.woznet_vpn_gw.id

  type                     = "ipsec.1"
  static_routes_only       = "true"
  local_ipv4_network_cidr  = "0.0.0.0/0"
  outside_ip_address_type  = "PublicIpv4"
  remote_ipv4_network_cidr = "0.0.0.0/0"
 
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "ToOurzoo"
  }
}

