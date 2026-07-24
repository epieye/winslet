resource "aws_vpc" "woznet_vpc" {
  cidr_block = "192.168.124.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  assign_generated_ipv6_cidr_block = false
    
  tags = {
    Name = "woznet-vpc"
  }
}

