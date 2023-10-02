locals {
  resource_group_name     = "KinaidaRG" # was ourzoo-azure-resources
  resource_group_location = "eastus"

  vnet1 = "172.16.0.0/24"
  #vnet2 = "172.16.1.0/24"

  vnet1_subnet1 = "172.16.0.0/25"
  vnet1_subnet2 = "172.16.0.128/25"
  #vnet2_subnet1 = "172.16.1.0/25"
}


    #next_hop_in_ip_address = "172.17.0.1"
    #address_prefix         = "192.168.0.0/16"
