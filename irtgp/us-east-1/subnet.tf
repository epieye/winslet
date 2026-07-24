#
#
#
#
#

resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = local.subnet1
  availability_zone = local.az1

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-${local.location}-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = local.subnet2
  availability_zone = local.az2

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet-${local.location}-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = local.subnet3
  availability_zone = local.az1
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-${local.location}-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = local.subnet4
  availability_zone = local.az2
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-${local.location}-subnet-private-1b"
  }
}

resource "aws_subnet" "woznet2_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc2.id
  cidr_block = local.subnet5
  availability_zone = local.az1
  map_public_ip_on_launch = "false"
 
  tags = {
    Name = "woznet2-${local.location}-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet2_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc2.id
  cidr_block = local.subnet6
  availability_zone = local.az2
  map_public_ip_on_launch = "false"
 
  tags = {
    Name = "woznet2-${local.location}-subnet-private-1b"
  }
}

