

resource "aws_internet_gateway" "woznet-igw" {
  vpc_id = aws_vpc.woznet_vpc1.id
  tags = {
    Name = "woznet-igw1"
  }
}
