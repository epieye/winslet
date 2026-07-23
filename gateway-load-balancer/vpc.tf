# I need three subnets for ingress, inspection, and egress. Or two if I use the palos for NAT instances.


resource "aws_vpc" "woznet_ingress_vpc" {
  cidr_block = "192.168.12.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "woznet-ingress-vpc"
  }
}

resource "aws_vpc" "woznet_egress_vpc" {
  cidr_block = "192.168.13.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-egress-vpc"
  }
}

