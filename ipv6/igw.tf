

resource "aws_internet_gateway" "woznet-igw" {
  vpc_id = aws_vpc.woznet_vpc.id
  tags = {
    Name = "woznet-igw"
  }
}
