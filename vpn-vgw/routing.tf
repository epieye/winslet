# Do I need public routing? It's only the NAT GWs

resource "aws_route_table" "woznet-crt" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = aws_vpn_gateway.woznet_vpn_gw.id
  }

  tags = {
    Name = "woznet-pub"
  }
} 

resource "aws_route_table_association" "woznet_subnet_public_1a" {
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  route_table_id = aws_route_table.woznet-crt.id
}

resource "aws_route_table_association" "woznet_subnet_public_1b" {
  subnet_id = aws_subnet.woznet_subnet_public_1b.id
  route_table_id = aws_route_table.woznet-crt.id
}

resource "aws_route_table" "woznet-rtb" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.woznet-ngw-b.id
  }

  route {
    cidr_block = "192.168.2.0/24"
    gateway_id = aws_vpn_gateway.woznet_vpn_gw.id
  }

  tags = {
    Name = "woznet-rtb"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_1a" {
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  route_table_id = aws_route_table.woznet-rtb.id
}

resource "aws_route_table_association" "woznet_subnet_private_1b" {
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  route_table_id = aws_route_table.woznet-rtb.id
}

resource "aws_vpn_connection_route" "vpn-route" {
  destination_cidr_block = "192.168.0.0/16"
  vpn_connection_id      = aws_vpn_connection.vpn_connection.id
}
