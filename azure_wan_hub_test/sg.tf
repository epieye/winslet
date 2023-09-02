resource "azurerm_network_security_group" "ourzoo_nsg" {
  name                = "ourzoo-security-group"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name 

  # Allow ssh to cotyer and clarissa

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
