

resource "aws_ec2_transit_gateway_route" "vpn_route_172" {
  destination_cidr_block         = "172.16.0.0/12"
  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id 
  transit_gateway_route_table_id = data.terraform_remote_state.transit_gateway.outputs.tgw_rtb_id
}

## 10/8 too until I decide. How does it already exist?
#resource "aws_ec2_transit_gateway_route" "vpn_route_10" {
#  destination_cidr_block         = "10.0.0.0/8"
#  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
#  transit_gateway_route_table_id = data.terraform_remote_state.transit_gateway.outputs.tgw_rtb_id
#}

resource "aws_ec2_transit_gateway_route_table_association" "vpn_association" {
  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id 
  transit_gateway_route_table_id = data.terraform_remote_state.transit_gateway.outputs.tgw_rtb_id
}

#output "vpn_connection" {
#  value = aws_vpn_connection.vpn_connection.id
#}



#resource "azurerm_virtual_hub_route_table" "example" {
#  name           = "example-vhubroutetable"
#  virtual_hub_id = azurerm_virtual_hub.vhub_vpn.id 
#  labels         = ["label1"]
#
#  route {
#    name              = "example-route"
#    destinations_type = "CIDR"
#    destinations      = ["192.168.0.0/16"]
#    next_hop_type     = "ResourceId"
#    next_hop          = azurerm_virtual_hub_connection.connection_vpn.id
#  }
#}

# What are the options? # VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None
resource "azurerm_route_table" "vnet1_rtb" {
  name                = "Vnet1-rtb"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  depends_on          = [ azurerm_resource_group.KinaidaRG ]

  route {
    name                   = "local"
    address_prefix         = local.vnet1
    next_hop_type          = "VnetLocal"
  }

  #route {
  #  name                   = "route_to_vnet2"
  #  address_prefix         = local.vnet2
  #  next_hop_type          = "VirtualAppliance" 
  #  #next_hop_in_ip_address = "172.16.1.1" # I'm not sure this is right.
  #}

  route {
    name                   = "route_to_aws_via_VPN"
    address_prefix         = "192.168.0.0/16"
    next_hop_type          = "VirtualNetworkGateway"
  }

  route {
    name                   = "default" # For now.
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

# Already exists or did this just already get applied?
resource "azurerm_subnet_route_table_association" "vnet1_rtb_assoc" {
  subnet_id      = azurerm_subnet.vnet1_subnet1.id # Can I make a list?
  route_table_id = azurerm_route_table.vnet1_rtb.id
}

#resource "azurerm_route_table" "vnet2_rtb" {
#  name                = "Vnet2-rtb"
#  location            = local.resource_group_location
#  resource_group_name = local.resource_group_name
#
#  route {
#    name                   = "local"
#    address_prefix         = local.vnet2
#    next_hop_type          = "VnetLocal"
#  }
#
#  # vnet1 is the gateway to everything, right?
#  # vnet2 gets traffic across the VPN. But it doesn't get back.
#  # => vnet2-rtb needs route to vnet1. 
#  # But if I add this, I loose connectivity. Perhaps it's not VirtualAppliance?
#  #route {
#  #  name                   = "route_to_vnet1"
#  #  address_prefix         = local.vnet1
#  #  next_hop_type          = "VirtualAppliance"
#  #  next_hop_in_ip_address = "172.16.1.1"
#  #}
#
#  #route {
#  #  name                   = "route_to_aws_via_VPN"
#  #  address_prefix         = "192.168.0.0/16"
#  #  next_hop_type          = "VirtualNetworkGateway"
#  #}
#
#  route {
#    name                   = "default"
#    address_prefix         = "0.0.0.0/0"
#    next_hop_type          = "VirtualNetworkGateway" # How does it know where the VirtualNetworkGateway is?
#    #next_hop_in_ip_address = "" # not needed for VirtualNetworkGateway
#    #next_hop_type          = "VirtualAppliance" # Options are "VirtualNetworkGateway" "VnetLocal" "Internet" "VirtualAppliance" "None"
#    #next_hop_in_ip_address = "172.16.1.1" # Tried 172.16.0.129 and 172.16.0.1. Also tried 172.16.1.1.  What other options are there? 
#  }
#}
#
#resource "azurerm_subnet_route_table_association" "vnet2_rtb_assoc" {
#  subnet_id      = azurerm_subnet.vnet2_subnet1.id
#  route_table_id = azurerm_route_table.vnet2_rtb.id
#}
