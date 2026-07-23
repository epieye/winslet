resource "aws_route_table" "woznet-public-rtb" {
  vpc_id = aws_vpc.woznet_kinaida_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw.id
  }

  #route {
  #  cidr_block = "192.168.16.0/20"
  #  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  #}

  tags = {
    Name = "woznet-public-rtb"
  }

  provider = aws.kinaida
} 

resource "aws_route_table_association" "woznet_subnet_public_1a" {
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  route_table_id = aws_route_table.woznet-public-rtb.id

  provider = aws.kinaida
}

resource "aws_route_table_association" "woznet_subnet_public_1b" {
  subnet_id = aws_subnet.woznet_subnet_public_1b.id
  route_table_id = aws_route_table.woznet-public-rtb.id

  provider = aws.kinaida
}
