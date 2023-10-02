resource azurerm_public_ip "VNet1GWpip1" {
  name = "VNet1GWpip1"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
  depends_on = [ azurerm_resource_group.KinaidaRG ]
}

resource azurerm_public_ip "VNet1GWpip2" {
  name = "VNet1GWpip2"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
  depends_on = [ azurerm_resource_group.KinaidaRG ]
}

resource azurerm_virtual_network_gateway "vng" {
  name = "VNet1GW" # change this to rg-azure-aws or maybe not
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  depends_on = [ azurerm_resource_group.KinaidaRG, azurerm_public_ip.VNet1GWpip1, azurerm_public_ip.VNet1GWpip2 ]

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
    subnet_id                     = azurerm_subnet.Gateway.id
  }
  ip_configuration {
  name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.VNet1GWpip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.Gateway.id
  }

  #vpn_client_configuration {
  #  address_space = ["192.168.0.0/16"] 
  #}
}

