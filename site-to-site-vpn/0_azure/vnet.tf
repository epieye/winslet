# Let's use the names and other values from the tutorial
# https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp
# It shouldn't matter because the AWS side doesn't know or care. But it might help me.

# Set this so it's easy to set more meaningful names when I understand the tutorial.
locals {
  resource_group_name     = azurerm_resource_group.TestRG1.name
  resource_group_location = azurerm_resource_group.TestRG1.location
}

resource "azurerm_resource_group" "TestRG1" { # was ourzoo
  name     = "TestRG1"         # was ourzoo-azure-resources
  location = "eastus"
}

resource "azurerm_network_security_group" "ourzoo" {
  name                = "ourzoo-security-group"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name 
}

resource "azurerm_virtual_network" "VNet1" {
  name                = "VNet1"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  address_space       = ["10.1.0.0/16"] # change to 172.10.0.0/16

  tags = {
    environment = "Experimental"
  }
}

# What are the address cidrs in real life?
resource "azurerm_subnet" "subnet1" {
  name                 = "FrontEnd"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet1.name
  address_prefixes     = ["10.1.0.0/24"] # change to 172.10.1.0/24
  #security_group       = azurerm_network_security_group.ourzoo # not expected here.
}

# Each virtual network can contain at most a single Virtual Network Gateway.
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNet1.name # not expected here.
  address_prefixes     = ["10.1.1.0/24"] # change to 172.10.0.0/27
  #security_group       = azurerm_network_security_group.ourzoo
}

# subnet1 and GatewaySubnet and two subnets in VNet1. Presumably I'm going to allocate a 10.245.something/16 to this. 
# Oh I do remember Todd talking about attaching the VPN directly to the transit gateway.


