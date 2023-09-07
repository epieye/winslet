resource "aws_route_table" "woznet3-crt" {
  vpc_id = aws_vpc.woznet_vpc3.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet3-crt"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_3a" {
  subnet_id = aws_subnet.woznet_subnet_private_3a.id
  route_table_id = aws_route_table.woznet3-crt.id
}

resource "aws_route_table_association" "woznet_subnet_private_3b" {
  subnet_id = aws_subnet.woznet_subnet_private_3b.id
  route_table_id = aws_route_table.woznet3-crt.id
}
