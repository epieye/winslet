

resource "aws_nat_gateway" "woznet-ngw-a" {
  subnet_id = aws_subnet.woznet_egress_subnet_public_1a.id

  tags = {
    Name = "woznet-ngw-a"
  }
}

resource "aws_nat_gateway" "woznet-ngw-b" {
  subnet_id = aws_subnet.woznet_egress_subnet_public_1b.id

  tags = {
    Name = "woznet-ngw-b"
  }
}
