#
#
#
#
#


# Similarly, Vnet2 (Clarissa)

# routing tables. vnet and hub. Wait.
# so routing tables for cotyer and clarissa. 10/8->VWAN. except local. cotyer default is public address. For now anyway. Until I can connect to Clarissa from Michio.




resource "azurerm_route_table" "VNet2_rt" {
  name                          = "vnet2_rt"
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = true

  route {
    name           = "toHub" 
    address_prefix = "10.77.21.0/24"
    next_hop_type  = "VnetLocal"
  }

  route {
    name                   = "toSpoke2"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.77.21.0/24"
  }

  #route {
  #  name                   = "toSpoke2"
  #  address_prefix         = "10.2.0.0/16"
  #  next_hop_type          = "VirtualAppliance"
  #  next_hop_in_ip_address = "10.0.0.36"
  #}

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VnetLocal"
  }

  tags = {
    environment = "experimental"
  }
}

resource "azurerm_subnet_route_table_association" "VNet2_rt_assoc" {
  subnet_id      = azurerm_subnet.subnet2.id
  route_table_id = azurerm_route_table.VNet2_rt.id
  #depends_on = [azurerm_subnet.hub-gateway-subnet]
}
