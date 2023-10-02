#
#
#
#
#

resource "azurerm_resource_group" "KinaidaRG" { # was ourzoo
  #name     = "KinaidaRG"                        # was ourzoo-azure-resources
  name      = local.resource_group_name
  #location = "eastus"
  location  = local.resource_group_location
}

