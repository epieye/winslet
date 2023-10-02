#
# 
#
#
#

resource "azurerm_virtual_network" "VNet1" {
  name                = "VNet1"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = [local.vnet1]
  depends_on = [azurerm_resource_group.KinaidaRG]

  tags = {
    environment = "Lab"
  }
}

#resource "azurerm_virtual_network" "VNet2" {
#  name                = "VNet2"
#  location            = local.resource_group_location
#  resource_group_name = local.resource_group_name
#  address_space       = [local.vnet2]
#  depends_on = [azurerm_resource_group.KinaidaRG]
#
#  tags = {
#    environment = "Experimental"
# }
#}

resource "azurerm_subnet" "vnet1_subnet1" {
  name                 = "vnet1_subnet1"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = [local.vnet1_subnet1]
  depends_on = [azurerm_virtual_network.VNet1]
}

#resource "azurerm_subnet" "vnet2_subnet1" {
#  name                 = "vnet2_subnet1"
#  resource_group_name  = local.resource_group_name
#  virtual_network_name = azurerm_virtual_network.VNet2.name
#  address_prefixes     = [local.vnet2_subnet1]
#  depends_on = [azurerm_virtual_network.VNet2]
#}

#resource "azurerm_virtual_network_peering" "peer_vnet1" {
#  name                      = "peer1to2"
#  resource_group_name       = local.resource_group_name
#  virtual_network_name      = azurerm_virtual_network.VNet1.name
#  remote_virtual_network_id = azurerm_virtual_network.VNet2.id
#
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#
#  allow_gateway_transit        = true
#}
#
## Does it need the reciprocal arrangement? 
#resource "azurerm_virtual_network_peering" "peer_vnet2" {
#  name                      = "peer2to1"
#  resource_group_name       = local.resource_group_name
#  virtual_network_name      = azurerm_virtual_network.VNet2.name
#  remote_virtual_network_id = azurerm_virtual_network.VNet1.id
#
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#
#  allow_gateway_transit        = true
#}

# Define the AWS Transit Gateway attachment
resource "aws_vpn_gateway_attachment" "gateway_attachment" {
  vpc_id = data.terraform_remote_state.transit_gateway.outputs.woznet1_vpc_id
  vpn_gateway_id     = aws_vpn_gateway.vpn_gw.id
  #transit_gateway_id = data.remote_state.transit_gateway
}

# Each virtual network can contain at most a single Virtual Network Gateway.
resource "azurerm_subnet" "Gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = [local.vnet1_subnet2]
}

# subnet1 and GatewaySubnet and two subnets in VNet1. Presumably I'm going to allocate a 10.245.something/16 to this. 
# Oh I do remember Todd talking about attaching the VPN directly to the transit gateway.

