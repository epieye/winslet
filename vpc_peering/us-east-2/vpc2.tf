
# The VPC can have resources in multiple regions. So why won't it let me create a subnet in us-east-2a?
resource "aws_vpc" "woznet_vpc2" {
  cidr_block = "192.168.174.0/23"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-vpc2"
  }
}

# 2 for vpc2 not region, still us-east-1. Is this confusing? Even more confusing, changed to us-east-2a.
resource "aws_subnet" "woznet_subnet_public_2a" {
  vpc_id = aws_vpc.woznet_vpc2.id
  cidr_block = "192.168.174.0/24"
  availability_zone = "us-east-2a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-subnet-public-2a"
  }
}

## I don't need a private subnet for this 
#resource "aws_subnet" "woznet_subnet_private_2a" {
#  vpc_id = aws_vpc.woznet_vpc2.id
#  cidr_block = "192.168.175.0/24"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = "false"
#
#  tags = {
#    Name = "woznet-subnet-private-2a"
#  }
#}

