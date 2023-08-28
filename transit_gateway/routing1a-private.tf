resource "aws_route_table" "woznet1a-private-crt" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0" 
    #gateway_id = aws_nat_gateway.woznet-ngw-a.id
    nat_gateway_id = aws_nat_gateway.woznet-ngw-a.id
  }

  route {
    cidr_block = aws_vpc.woznet_vpc2.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet1a-private-crt"
  }
} 

resource "aws_route_table_association" "woznet_subnet_private_1a" {
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  route_table_id = aws_route_table.woznet1a-private-crt.id
}

