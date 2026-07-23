resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_kinaida_vpc.id
  cidr_block = "192.168.2.0/24"
  
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet1-subnet-private-1a"
  }

  provider = aws.kinaida
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_kinaida_vpc.id
  cidr_block = "192.168.3.0/24"
 
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-subnet-private-1b"
  }

  provider = aws.kinaida
}

