resource "aws_route_table" "woznet2-crt" {
  vpc_id = aws_vpc.woznet_vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet2-crt"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_2a" {
  subnet_id = aws_subnet.woznet_subnet_private_2a.id
  route_table_id = aws_route_table.woznet2-crt.id
}

resource "aws_route_table_association" "woznet_subnet_private_2b" {
  subnet_id = aws_subnet.woznet_subnet_private_2b.id
  route_table_id = aws_route_table.woznet2-crt.id
}
