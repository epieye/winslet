
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

resource "aws_vpc" "woznet_vpc3" {
  cidr_block = "192.168.14.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-vpc3-London"
  }
}

resource "aws_vpc" "woznet_vpc4" {
  cidr_block = "192.168.15.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-vpc4-Ohio"
  }
}

#resource "aws_vpc" "woznet_vpc5" {
#  cidr_block = "192.168.16.0/24"
#
#  enable_dns_support   = "true"
#  enable_dns_hostnames = "true"
#
#  tags = {
#    Name = "woznet-vpc5-Melbourne"
#  }
#}
#
#resource "aws_vpc" "woznet_vpc6" {
#  cidr_block = "192.168.17.0/24"
#
#  enable_dns_support   = "true"
#  enable_dns_hostnames = "true"
#
#  tags = {
#    Name = "woznet-vpc6-Cape-Town"
#  }
#}

