resource "aws_vpc" "woznet_vpc1" {
  cidr_block = local.cidr1

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "woznet-vpc1-${local.location}"
  }
}

resource "aws_vpc" "woznet_vpc2" {
  cidr_block = local.cidr2
 
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
 
  tags = {
    Name = "woznet-vpc2-${local.location}"
  }
}

