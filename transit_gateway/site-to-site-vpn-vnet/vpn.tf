
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id                     = aws_customer_gateway.ToAzureInstance0.id

  #vpn_gateway_id = aws_vpn_gateway.vpn_gw.id  # Should I just make this the transit gateway ID?
  transit_gateway_id  = data.terraform_remote_state.transit_gateway.outputs.tgw_id

  type                                    = "ipsec.1"
  #static_routes_only                      = var.vpn_connection_static_routes_only
  static_routes_only = "true"

  #local_ipv4_network_cidr                 = var.vpn_connection_local_ipv4_network_cidr
  local_ipv4_network_cidr = "172.16.0.0/12" # Was "10.0.0.0/24"

  #outside_ip_address_type                 = var.vpn_connection_outside_ip_address_type
  outside_ip_address_type = "PublicIpv4"

  #remote_ipv4_network_cidr                = var.vpn_connection_remote_ipv4_network_cidr
  remote_ipv4_network_cidr = "192.168.0.0/16" # Was "10.0.1.0/24"
 
  # There are loads of settings. Revisit them when it's working.
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "ToAzure"
  }
}
