# Public subnets are needed for NGWs

resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  #cidr_block = "192.168.147.0/25"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  #cidr_block = "192.168.147.128/25"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-subnet-private-1b"
  }
}
