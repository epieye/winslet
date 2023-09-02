# Virtual WAN
resource "azurerm_virtual_wan" "vwan1" {
  name = "WozWAN"
  resource_group_name = local.resource_group_name
  location = local.resource_group_location
  depends_on = [azurerm_resource_group.resource_group, azurerm_subnet.subnet1, azurerm_subnet.subnet2]

  ## Configuration 
  #office365_local_breakout_category = "OptimizeAndAllow"
  #tags = {
  #  Environment = var.environment_tag
  #}
}

# Hubs. I like this because itazurerm_virtual_hub.vhub1 feels more like a physical router with addresses. 
resource "azurerm_virtual_hub" "vhub1" {
  name                = "hub1"
  resource_group_name = local.resource_group_name
  location = local.resource_group_location
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  address_prefix      = "10.67.20.0/24"  # this (apparently) is not the address space of the spoke network. 
  tags = {
    Environment = "dev"
  }
}

resource "azurerm_virtual_hub" "vhub2" {
  name                = "hub2"
  resource_group_name = local.resource_group_name # Do/can the hubs have to be in different RGs
  location = local.resource_group_location
  virtual_wan_id      = azurerm_virtual_wan.vwan1.id
  address_prefix      = "10.67.21.0/24"
  tags = {
    Environment = "dev"
  }
}

## Address space?
#aws 192.168.12 13 14 .... /24s mostly IIRC
#azure   10 172 ?? Or 192.168.100 ...
#even gcp lol         192.168.200 ...
#
#
#Better on cidr boundaries
#
#192.168.0.0/18 = 192.168.0.0 192.168.64.0 192.168.0.0
#
#10.239
#10.245 -> 10.244/15
#10.247 -> 10.246/15
#10.249 -> 10.248/15
#
#I could do 10.242/15 for Azure or 10.250/15


# Virtual WAN Connections transit gateway attachments? spoke. 
resource "azurerm_virtual_hub_connection" "connection1" {
  name                      = "vnet1"
  virtual_hub_id            = azurerm_virtual_hub.vhub1.id
  remote_virtual_network_id = azurerm_virtual_network.VNet1.id
}

resource "azurerm_virtual_hub_connection" "connection2" {
  name                      = "vnet2"
  virtual_hub_id            = azurerm_virtual_hub.vhub2.id
  remote_virtual_network_id = azurerm_virtual_network.VNet2.id
}


#Azure Firewall vs Azure SGs

# What about the routing?



#[warren@Rocinante warren] $ # The virtual hub exists in a RG. 
#[warren@Rocinante warren] $ # How does this work with other RGs and subscriptions.
#[warren@Rocinante warren] $ https://jakewalsh.co.uk/deploying-azure-virtual-wan-using-terraform/


