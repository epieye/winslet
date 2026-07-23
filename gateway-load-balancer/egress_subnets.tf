
resource "aws_subnet" "woznet_egress_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_egress_vpc.id
  cidr_block = "192.168.13.0/27"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-egress-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_egress_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_egress_vpc.id
  cidr_block = "192.168.13.32/27"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet-egress-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_egress_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_egress_vpc.id
  cidr_block = "192.168.13.128/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-egress-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_egress_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_egress_vpc.id
  cidr_block = "192.168.13.192/27"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-egress-subnet-private-1b"
  }
}

