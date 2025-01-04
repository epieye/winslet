#
# local and remote network and vlan assignments. 
#

# Ourzoo is 192.168.1.0/24
# Kinaida is 192.168.      <-

# The VPN is going to be associated with the Transit Gateway, not a VPC.


#locals {
#  vnet1         = "10.208.0.0/24"    # Random allocation away from 10.240.0.0/12
#  vnet1_subnet1 = "10.208.0.0/25"    # avd_subnet
#  vnet1_subnet2 = "10.208.0.128/25"  # gateway_subnet
#
#  remote_cidr   = "10.240.0.0/12"
#}

