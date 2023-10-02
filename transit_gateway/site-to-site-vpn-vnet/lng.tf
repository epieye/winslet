resource "azurerm_local_network_gateway" "home" {
  name                = "backHome"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  gateway_address     = aws_vpn_connection.vpn_connection.tunnel1_address
  address_space       = ["192.168.0.0/16"] # Assuming it means the AWS side
}

resource "azurerm_local_network_gateway" "home2" {
  name                = "backHome2"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  gateway_address     = aws_vpn_connection.vpn_connection.tunnel2_address
  address_space       = ["192.168.0.0/16"] # Assuming it means the AWS side
}

# make a loop so I don't repeat the same settings.

# This seems to destroy, but the gateway won't destroy because it still exists.
resource "azurerm_virtual_network_gateway_connection" "home" {
  name                = "vgw-vpn-connection"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  virtual_network_gateway_id     = azurerm_virtual_network_gateway.vng.id  

  #remote_virtual_network {
  #  address_space = ["192.168.0.0/16"]
  #}

  type                           = "IPsec"
  
  connection_protocol            = "IKEv2"
  enable_bgp                     = false
  local_azure_ip_address_enabled = false

  #virtual_network_gateway_id     = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id       = azurerm_local_network_gateway.home.id

  dpd_timeout_seconds            = 45

  shared_key          = aws_vpn_connection.vpn_connection.tunnel1_preshared_key

  ipsec_policy {
    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA1"
    pfs_group        = "PFS2"
  }  
}

# This seems to destroy, but the gateway won't destroy because it still exists.
resource "azurerm_virtual_network_gateway_connection" "home2" {
  name                = "vgw-vpn-connection2"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location

  virtual_network_gateway_id     = azurerm_virtual_network_gateway.vng.id

  #remote_virtual_network {
  #  address_space = ["10.1.0.0/16"] # I'm not using this but change it to 172.16.something
  #}

  type                           = "IPsec"

  connection_protocol            = "IKEv2"
  enable_bgp                     = false
  local_azure_ip_address_enabled = false

  #virtual_network_gateway_id     = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id       = azurerm_local_network_gateway.home2.id

  dpd_timeout_seconds            = 45

  shared_key          = aws_vpn_connection.vpn_connection.tunnel2_preshared_key

  ipsec_policy {
    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA1"
    pfs_group        = "PFS2"
  } 
}

