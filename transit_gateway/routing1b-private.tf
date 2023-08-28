resource "aws_route_table" "woznet1b-private-crt" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0" 
    #gateway_id = aws_nat_gateway.woznet-ngw-b.id
    nat_gateway_id = aws_nat_gateway.woznet-ngw-b.id
  }

  route {
    cidr_block = aws_vpc.woznet_vpc2.cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet1b-private-crt"
  }
} 

resource "aws_route_table_association" "woznet_subnet_private_1b" {
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  route_table_id = aws_route_table.woznet1b-private-crt.id
}
