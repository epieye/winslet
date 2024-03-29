# I found it has to be public to use my user data. 
# use transit-gateway folder for more advanced networking.

resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.12.0/27"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet1-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.12.32/27"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet1-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.12.128/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet1-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a-2" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.12.160/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet1-subnet-private-1a-2"
  }
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc1.id
  cidr_block = "192.168.12.192/27"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-subnet-private-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_2a" {
  vpc_id = aws_vpc.woznet_vpc2.id
  cidr_block = "192.168.13.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet2-subnet-private-2a"
  }
}

resource "aws_subnet" "woznet_subnet_private_2b" {
  vpc_id = aws_vpc.woznet_vpc2.id
  cidr_block = "192.168.13.128/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet2-subnet-private-2b"
  }
}




resource "aws_subnet" "woznet_subnet_private_3a" {
  vpc_id = aws_vpc.woznet_vpc3.id
  cidr_block = "192.168.14.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet3-subnet-private-3a"
  }
}

resource "aws_subnet" "woznet_subnet_private_3b" {
  vpc_id = aws_vpc.woznet_vpc3.id
  cidr_block = "192.168.14.128/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet3-subnet-private-3b"
  }
}


resource "aws_subnet" "woznet_subnet_private_4a" {
  vpc_id = aws_vpc.woznet_vpc4.id
  cidr_block = "192.168.15.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet4-subnet-private-4a"
  }
}

resource "aws_subnet" "woznet_subnet_private_4b" {
  vpc_id = aws_vpc.woznet_vpc4.id
  cidr_block = "192.168.15.128/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet4-subnet-private-4b"
  }
}

