
# rename vpc1 to ingress vpc
# and vpc is the egress vpc

# i see why we did things this way but
# does it mean anuything in vpc1 must use igw
# create a third vpc that will use tgw and ngw

# create a third vpc for naomi and sadavir in another region for transit gateway.
# Perhaps London? Internet via Atlanta or sepatate igw?
# first things first. I need esteban and michio to get internet access.



resource "aws_vpc" "woznet_vpc1" {
  cidr_block = "192.168.12.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "woznet-vpc1"
  }
}

resource "aws_vpc" "woznet_vpc2" {
  cidr_block = "192.168.13.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-vpc2"
  }
}




