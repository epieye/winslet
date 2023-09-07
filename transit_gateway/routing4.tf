resource "aws_route_table" "woznet4-crt" {
  vpc_id = aws_vpc.woznet_vpc4.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet4-crt"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_4a" {
  subnet_id = aws_subnet.woznet_subnet_private_4a.id
  route_table_id = aws_route_table.woznet4-crt.id
}

resource "aws_route_table_association" "woznet_subnet_private_4b" {
  subnet_id = aws_subnet.woznet_subnet_private_4b.id
  route_table_id = aws_route_table.woznet4-crt.id
}
