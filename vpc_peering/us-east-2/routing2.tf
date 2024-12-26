resource "aws_route_table" "woznet2-crt" {
  vpc_id = aws_vpc.woznet_vpc2.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw2.id
  }

  route {
    cidr_block = aws_vpc.woznet_vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "woznet2-crt"
  }
} 

resource "aws_route_table_association" "woznet_subnet_public_2a" {
  subnet_id = aws_subnet.woznet_subnet_public_2a.id
  route_table_id = aws_route_table.woznet2-crt.id
}

