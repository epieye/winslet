

# Create public IPs. Temporary. Once operational, the only access will be via the s2s VPN Tunnel and TGW.
resource "azurerm_public_ip" "cotyer_public_ip" {
  name                = "CotyerPublicIP"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
}


# Create network interface
resource "azurerm_network_interface" "cotyer_nic" {
  name                = "Cotyer_NIC"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_public_ip.cotyer_public_ip]

  ip_configuration {
    name                          = "cotyer_nic_configuration"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cotyer_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "cotyer_assoc" {
  network_interface_id      = azurerm_network_interface.cotyer_nic.id
  network_security_group_id = azurerm_network_security_group.ourzoo_nsg.id
}




# What is this?
## Generate random text for a unique storage account name
#resource "random_id" "random_id" {
#  keepers = {
#    # Generate a new ID only when a new resource group is defined
#    resource_group = local.resource_group_name
#  }
#
#  byte_length = 8
#}
#
## Create storage account for boot diagnostics
#resource "azurerm_storage_account" "my_storage_account" {
#  name                     = "diag${random_id.random_id.hex}"
#  location                 = local.resource_group_location
#  resource_group_name      = local.resource_group_name
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}



# Create virtual machine
resource "azurerm_linux_virtual_machine" "cotyer_vm" {
  name                  = "cotyer"
  location              = local.resource_group_location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.cotyer_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "cotyer_OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "cotyer"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.Athens_ssh.public_key_openssh
  }

  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  #}
}


# Create cotyar.internal.kinaida.net and clarissa.internal.kinaida.net
# Maybe cotyar.kinaida.net just for testing
# ooh. How do I associate with the VPC?
# Is there a user_data so that I can create a user?
# Or What is the right way to retrieve the private key to ssh to azureuser?
# sudo apt update
# sudo apt install net-tools

resource "aws_route53_record" "cotyer" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "cotyer.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [azurerm_public_ip.cotyer_public_ip.ip_address]
}
