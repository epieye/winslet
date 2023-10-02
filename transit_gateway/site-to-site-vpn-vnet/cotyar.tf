

#data "template_file" "user_data" {
#  template = file("${path.module}/user_data.sh")
#}

## Create public IPs. Temporary. Once operational, the only access will be via the s2s VPN Tunnel and TGW.
#resource "azurerm_public_ip" "cotyar_public_ip" {
#  name                = "CotyarPublicIP"
#  location            = local.resource_group_location
#  resource_group_name = local.resource_group_name
#  allocation_method   = "Dynamic"
#  depends_on = [ azurerm_resource_group.KinaidaRG ]
#}


# Create network interface
resource "azurerm_network_interface" "cotyar_nic" {
  name                = "cotyar_nic"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "cotyar_nic_configuration"
    subnet_id                     = azurerm_subnet.vnet1_subnet1.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.cotyar_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "cotyar_assoc" {
  network_interface_id      = azurerm_network_interface.cotyar_nic.id
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
resource "azurerm_linux_virtual_machine" "cotyar_vm" {
  name                  = "cotyar"
  location              = local.resource_group_location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.cotyar_nic.id]
  size                  = "Standard_DS1_v2"
  #custom_data           = filebase64(data.template_file.user_data.rendered)
  custom_data           = filebase64("${path.module}/user_data.sh")

  os_disk {
    name                 = "cotyar_OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "cotyar"
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

#resource "aws_route53_record" "cotyar" {
#  zone_id     = "Z07643963KV3I332WTGCB"
#  name       = "cotyar.kinaida.net"
#  type       = "A"
#  ttl        = "60"
#  records    = [azurerm_public_ip.cotyar_public_ip.ip_address]
#  #depends_on = [azurerm_public_ip.cotyar_public_ip]
#}

resource "aws_route53_record" "cotyar_internal" {
  zone_id = data.terraform_remote_state.transit_gateway.outputs.internal_zone_id
  name    = "cotyar.internal.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [azurerm_network_interface.cotyar_nic.private_ip_address]
}
