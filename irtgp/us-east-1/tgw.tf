resource "aws_ec2_transit_gateway" "woznet-tg" {
  description = "woznet-${local.location}-tg"
  auto_accept_shared_attachments = "enable"

  tags = {
    "Name" = "Woznet-${local.location}-tg"
  }

  default_route_table_association = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "woznet1" {
  subnet_ids         = [
    aws_subnet.woznet_subnet_private_1a.id, 
    aws_subnet.woznet_subnet_private_1b.id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  vpc_id             = aws_vpc.woznet_vpc1.id 

  tags = {
    "Name" = "Woznet-${local.location}-tgwa1"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "woznet2" {
  subnet_ids         = [
    aws_subnet.woznet2_subnet_private_1a.id,
    aws_subnet.woznet2_subnet_private_1b.id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  vpc_id             = aws_vpc.woznet_vpc2.id

  tags = {
    "Name" = "Woznet-${local.location}-tgwa2"
  }
}

