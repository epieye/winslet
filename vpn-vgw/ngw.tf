resource "aws_nat_gateway" "woznet-ngw-a" {
  allocation_id = aws_eip.woznet-eip-a.id
  subnet_id = aws_subnet.woznet_subnet_public_1a.id

  tags = {
    Name = "woznet-ngw-a"
  }

  depends_on = [aws_internet_gateway.woznet-igw]
}

resource "aws_nat_gateway" "woznet-ngw-b" {
  allocation_id = aws_eip.woznet-eip-b.id
  subnet_id = aws_subnet.woznet_subnet_public_1b.id

  tags = {
    Name = "woznet-ngw-b"
  }

  depends_on = [aws_internet_gateway.woznet-igw]
}
