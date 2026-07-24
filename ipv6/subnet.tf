resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  #cidr_block = "192.168.12.0/27"
  ipv6_cidr_block   = cidrsubnet(aws_vpc.woznet_vpc.ipv6_cidr_block, 8, 0)
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  assign_ipv6_address_on_creation = "true"
  enable_dns64                    = "true"      


  tags = {
    Name = "woznet-subnet-public-1a"
  }
}

#resource "aws_subnet" "woznet_subnet_public_1b" {
#  vpc_id = aws_vpc.woznet_vpc.id
#  #cidr_block = "192.168.12.32/27"
#  availability_zone = "us-east-1b"
#
#  #map_public_ip_on_launch = "true" 
#
#  assign_ipv6_address_on_creation = "true"
#  enable_dns64                    = "true"
#
#  tags = {
#    Name = "woznet1-subnet-public-1b"
#  }
#}
#
#resource "aws_subnet" "woznet_subnet_private_1a" {
#  vpc_id = aws_vpc.woznet_vpc.id
#  cidr_block = "192.168.12.128/27"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = "false"
#
#  tags = {
#    Name = "woznet1-subnet-private-1a"
#  }
#}
#
#resource "aws_subnet" "woznet_subnet_private_1b" {
#  vpc_id = aws_vpc.woznet_vpc.id
#  cidr_block = "192.168.12.192/27"
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = "false"
#
#  tags = {
#    Name = "woznet-subnet-private-1b"
#  }
#}
