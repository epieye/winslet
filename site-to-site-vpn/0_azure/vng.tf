

resource azurerm_public_ip "VNet1GWpip1" {
  name = "VNet1GWpip1"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"

  # How do I make this wait until the addresses are available. 
  # I have to run apply twice so the address are in the output
}

resource azurerm_public_ip "VNet1GWpip2" {
  name = "VNet1GWpip2"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
}

resource azurerm_virtual_network_gateway "vng" {
  name = "VNet1GW" # change this to rg-azure-aws or maybe not
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  type = "Vpn"
  vpn_type = "RouteBased"
  
  active_active = true          # the other example says false. I'd rather have both.
  enable_bgp    = false
  sku           = "VpnGw2"      # Was VpnGw2 Does this even mean anything? Limited options, but what do they mean?
  generation    = "Generation2" # Was 2

  # an active-active gateway requires exactly two ip_configuration blocks.
  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.VNet1GWpip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
  ip_configuration {
  name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.VNet1GWpip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
}


## from the tutorial:
#
#Name: VNet1GW
#Region: East US
#Gateway type: VPN
#VPN type: Route-based
#SKU: VpnGw2AZ
#Generation: Generation2
#Virtual network: VNet1
#Gateway subnet address range: 10.1.1.0/24
#
#Public IP address: Create new
#Public IP address name: VNet1GWpip
#Availability zone: Zone-redundant
#Enable active-active mode: Enabled
#
#SECOND PUBLIC IP ADDRESS: Create new
#Public IP address 2 name: VNet1GWpip2
#Availability zone: Zone-redundant
#
#Configure BGP: Enabled
#Autonomous system number (ASN): 65000
#Custom Azure APIPA BGP IP address: 169.254.21.2, 169.254.22.2
#Second Custom Azure APIPA BGP IP address: 169.254.21.6, 169.254.22.6
