resource "aws_route_table" "woznet-public-rtb" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet-${local.location}-public-rtb"
  }
} 

resource "aws_route_table_association" "woznet_subnet_public_1a" {
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  route_table_id = aws_route_table.woznet-public-rtb.id
}

resource "aws_route_table_association" "woznet_subnet_public_1b" {
  subnet_id = aws_subnet.woznet_subnet_public_1b.id
  route_table_id = aws_route_table.woznet-public-rtb.id
}

#---

resource "aws_route_table" "woznet-private-a-rtb" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.woznet-ngw-a.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet-${local.location}-private-a-rtb"
  }

  depends_on = [aws_ec2_transit_gateway.woznet-tg]
}

resource "aws_route_table_association" "woznet_subnet_private_1a" {
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  route_table_id = aws_route_table.woznet-private-a-rtb.id
}

resource "aws_route_table" "woznet-private-b-rtb" {
  vpc_id = aws_vpc.woznet_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.woznet-ngw-b.id
  }

  route {
    cidr_block = "192.168.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }

  tags = {
    Name = "woznet-${local.location}-private-rtb"
  }

  depends_on = [aws_ec2_transit_gateway.woznet-tg]
}

resource "aws_route_table_association" "woznet_subnet_private_1b" {
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  route_table_id = aws_route_table.woznet-private-b-rtb.id
}

# ---

resource "aws_route_table" "woznet2-private-rtb" {
  vpc_id = aws_vpc.woznet_vpc2.id
 
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  }
 
  tags = {
    Name = "woznet2-${local.location}-private-rtb"
  }
 
  depends_on = [aws_ec2_transit_gateway.woznet-tg]
}

resource "aws_route_table_association" "woznet2_subnet_private_1a" {
  subnet_id = aws_subnet.woznet2_subnet_private_1a.id
  route_table_id = aws_route_table.woznet2-private-rtb.id
}

resource "aws_route_table_association" "woznet2_subnet_private_1b" {
  subnet_id = aws_subnet.woznet2_subnet_private_1b.id
  route_table_id = aws_route_table.woznet2-private-rtb.id
}

# ---

resource "aws_ec2_transit_gateway_route_table" "woznet-tg-rtb" {
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id

  tags = {
    Name = "woznet-${local.location}-tg-rtb" 
  }
}

resource "aws_ec2_transit_gateway_route" "last_resort" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
}

resource "aws_ec2_transit_gateway_route" "custom_routes" {
  destination_cidr_block         = local.cidr1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "associations" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
}

resource "aws_ec2_transit_gateway_route" "custom_routes2" {
  destination_cidr_block         = local.cidr2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "associations2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet-tg-rtb.id
}


