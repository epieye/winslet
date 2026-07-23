################################################################
#                                                              #
# two routing tables because 1a routes out the NatGW in 1a and #
#                            1b routes out the NatGW in 1b     #
#                                                              #
################################################################

#resource "aws_route_table" "woznet_public_rtb" {
#  vpc_id = aws_vpc.woznet_vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.woznet-igw.id
#  }
#
#  tags = {
#    Name = "woznet-pub-rtb"
#  }
#}
#
#resource "aws_route_table_association" "woznet_subnet_public_1a" {
#  subnet_id = aws_subnet.woznet_subnet_public_1a.id
#  route_table_id = aws_route_table.woznet_public_rtb.id
#}
#
#resource "aws_route_table_association" "woznet_subnet_public_1b" {
#  subnet_id = aws_subnet.woznet_subnet_public_1b.id
#  route_table_id = aws_route_table.woznet_public_rtb.id
#}

resource "aws_route_table" "woznet_private_1a_rtb" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.woznet-ngw-a.id
  }

  route {
    cidr_block = "10.0.0.0/8" 
    gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet1a-rtb"
  }
} 

resource "aws_route_table_association" "woznet_subnet_private_1a" {
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  route_table_id = aws_route_table.woznet_private_1a_rtb.id
}

# Static routes for vpn-0b3fd1b8d94948971 must be added through the Transit Gateway API.
#resource "aws_vpn_connection_route" "vpn-route" {
#  destination_cidr_block = "192.168.0.0/16"
#  vpn_connection_id      = aws_vpn_connection.vpn_connection.id
#}

resource "aws_route_table" "woznet_private_1b_rtb" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.woznet-ngw-b.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet1b-rtb"
  }
}

resource "aws_route_table_association" "woznet_subnet_private_1b" {
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  route_table_id = aws_route_table.woznet_private_1b_rtb.id
}

resource "aws_route_table" "woznet2_private_rtb" {
  vpc_id = aws_vpc.woznet_vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet2-rtb"
  }
}

resource "aws_route_table_association" "woznet2_subnet_private_1a" {
  subnet_id = aws_subnet.woznet2_subnet_private_1a.id
  route_table_id = aws_route_table.woznet2_private_rtb.id
}

resource "aws_route_table_association" "woznet2_subnet_private_1b" {
  subnet_id = aws_subnet.woznet2_subnet_private_1b.id
  route_table_id = aws_route_table.woznet2_private_rtb.id
}



