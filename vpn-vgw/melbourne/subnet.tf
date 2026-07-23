
resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-southeast-4a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-melbourne-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone = "ap-southeast-4b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet-melbourne-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.3.0/24"
  availability_zone = "ap-southeast-4a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-melbourne-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.4.0/24"
  availability_zone = "ap-southeast-4b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-melbourne-subnet-private-1b"
  }
}
