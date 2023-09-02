# https://learn.microsoft.com/en-us/azure/developer/terraform/hub-spoke-hub-nva
# Where is the terraform documentation on this?

# routing tables. vnet and hub. Wait.
# so routing tables for cotyer and clarissa. 10/8->VWAN. except local. cotyer default is public address. For now anyway. Until I can connect to Clarissa from Michio.

#resource "azurerm_route_table" "default_routes" {
#  name                = "Do_you_mean_the_name_of_the_routing_table"
#  location            = local.resource_group_location
#  resource_group_name = local.resource_group_name
#
#  #dynamic "route" {
#  #  for_each =       each.value.address_prefix
#  # 
#  #  content {
#  #    name = each.value.name
#  #    address_prefix = route.value
#  #    next_hop_type = "VnetLocal"
#  #  }
#  #}
#
#  # cotyer: default route is public address.
#  route {
#    name                   = "Default"
#    address_prefix         = "0.0.0.0/0"
#    next_hop_type          = ""
#    next_hop_in_ip_address = 
#  }
#}
#
#
#
#
#
#resource "azurerm_subnet_route_table_association" "subnet_associations" {
#  subnet_id = 
#  #route_table_id = azurerm_route_table.default_routes[each.value.name].id # use this later
#  route_table_id = azurerm_route_table.default_routes.id
#}

# VNet1 (cotyer). local, 10/8, and default is the Internet. Until I can connect to Clarissa from Michio via s2s.
resource "azurerm_route_table" "VNet1_rt" {
  name                          = "vnet1_rt"
  location                      = local.resource_group_location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = true

  route {
    name           = "toHub" 
    address_prefix = "10.77.20.0/24" # I assume this is local as it says "VnetLocal" but what does "toHub" mean?
    next_hop_type  = "VnetLocal"
  }

  route {
    name                   = "toSpoke1"
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

  # next_hop_type is one of [VirtualNetworkGateway VnetLocal Internet VirtualAppliance None]
  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "experimental"
  }
}

resource "azurerm_subnet_route_table_association" "VNet1_rt_assoc" {
  subnet_id      = azurerm_subnet.subnet1.id
  route_table_id = azurerm_route_table.VNet1_rt.id
  #depends_on = [azurerm_subnet.hub-gateway-subnet]
}


# Similarly, Vnet2 (Clarissa)

# routing tables. vnet and hub. Wait.
# so routing tables for cotyer and clarissa. 10/8->VWAN. except local. cotyer default is public address. For now anyway. Until I can connect to Clarissa from Michio.


