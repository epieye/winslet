

resource "aws_vpc" "woznet_vpc1" {
  cidr_block = "192.168.172.0/23"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "woznet-vpc1"
  }
}

resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.172.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet1-subnet-public-1a"
  }
}

# Do I even need a private subnet?
#resource "aws_subnet" "woznet_subnet_private_1a" {
#  vpc_id = aws_vpc.woznet_vpc1.id
#  cidr_block = "192.168.173.0/24"
#  availability_zone = "us-east-1a"
#
#  map_public_ip_on_launch = "false"
#
#  tags = {
#    Name = "woznet1-subnet-private-1a"
#  }
#}

