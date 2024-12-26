resource "aws_route_table" "woznet1-crt" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw1.id
  }

  route {
    cidr_block = aws_vpc.woznet_vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "woznet1-crt"
  }
} 

resource "aws_route_table_association" "woznet_subnet_public_1a" {
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  route_table_id = aws_route_table.woznet1-crt.id
}

