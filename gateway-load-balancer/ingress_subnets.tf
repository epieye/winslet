
resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  cidr_block = "192.168.12.0/27"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-ingress-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  cidr_block = "192.168.12.32/27"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet-ingress-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_ingress_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  cidr_block = "192.168.12.128/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-ingress-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_ingress_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  cidr_block = "192.168.12.192/27"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-ingress-subnet-private-1b"
  }
}

