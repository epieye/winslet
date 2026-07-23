#
#
# It's starting to look a lot like Christmas. 
# Just the same as virtual private gateway, but declare transit_gateway_id instead.
#
#

resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.ToOurzoo.id
 
  #vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  transit_gateway_id  = aws_ec2_transit_gateway.woznet-tg.id
 
  type = "ipsec.1"
  static_routes_only = "true"
  local_ipv4_network_cidr = "0.0.0.0/0" # 10
  outside_ip_address_type = "PublicIpv4"
  remote_ipv4_network_cidr = "0.0.0.0/0" # 192

  tunnel1_preshared_key = "mytunnel1psk"
  tunnel2_preshared_key = "mytunnel2psk"
 
  # There are loads of settings. Revisit them when it's working.
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]
 
  tags = {
    Name = "ToOurzoo"
  }
}

