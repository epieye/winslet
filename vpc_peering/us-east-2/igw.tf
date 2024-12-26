

resource "aws_internet_gateway" "woznet-igw2" {
  vpc_id = aws_vpc.woznet_vpc2.id
  tags = {
    Name = "woznet-igw2"
  }
}

