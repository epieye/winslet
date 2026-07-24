resource "aws_vpc" "woznet_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  # enable ipv6
  assign_generated_ipv6_cidr_block = true
  
  tags = {
    Name = "woznet-vpc"
  }
}
