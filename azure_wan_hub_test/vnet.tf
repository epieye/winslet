#
#
# 
#
#

#resource "azurerm_resource_group" "resource_group" {
#  name     = local.resource_group_name
#  location = local.resource_group_location
#}

resource "azurerm_virtual_network" "VNet1" {
  name                = "VNet1"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = ["10.77.20.0/24"]

  tags = {
    environment = "Lab"
  }
}

resource "azurerm_virtual_network" "VNet2" {
  name                = "VNet2"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = ["10.77.21.0/24"]

  tags = {
    environment = "Experimental"
 }
}

# What are the address cidrs in real life?
resource "azurerm_subnet" "subnet1" {
  name                 = "vnet1_subnet1"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = ["10.77.20.0/25"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "vnet2_subnet2"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet2.name
  address_prefixes     = ["10.77.21.0/25"] 
}



# Each virtual network can contain at most a single Virtual Network Gateway.
#resource "azurerm_subnet" "gateway" {
#  name                 = "GatewaySubnet"
#  resource_group_name  = local.resource_group_name
#  virtual_network_name = azurerm_virtual_network.VNet1.name # not expected here.
#  address_prefixes     = ["10.1.1.0/24"] # change to 172.10.0.0/27 or 192.168? No. 
#}
#
## subnet1 and GatewaySubnet and two subnets in VNet1. Presumably I'm going to allocate a 10.245.something/16 to this. 
## Oh I do remember Todd talking about attaching the VPN directly to the transit gateway.
#
