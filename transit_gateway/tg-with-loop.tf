resource "aws_ec2_transit_gateway" "woznet-tg" {
  description = "woznet-tg"
  auto_accept_shared_attachments = "enable"

  tags = {
    "Name" = "Woznet-tg"
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
    "Name" = "Woznet1-tgwa"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "woznet2" {
  subnet_ids         = [
    aws_subnet.woznet_subnet_private_2a.id, 
    aws_subnet.woznet_subnet_private_2b.id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  vpc_id             = aws_vpc.woznet_vpc2.id    

  tags = {
    "Name" = "Woznet2-tgwa"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "woznet3" {
  subnet_ids         = [
    aws_subnet.woznet_subnet_private_3a.id,
    aws_subnet.woznet_subnet_private_3b.id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  vpc_id             = aws_vpc.woznet_vpc3.id   

  tags = {
    "Name" = "Woznet3-tgwa"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "woznet4" {
  subnet_ids         = [
    aws_subnet.woznet_subnet_private_4a.id,
    aws_subnet.woznet_subnet_private_4b.id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
  vpc_id             = aws_vpc.woznet_vpc4.id

  tags = {
    "Name" = "Woznet4-tgwa"
  }
}

resource "aws_ec2_transit_gateway_route_table" "woznet" {
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
}

#output "woznet_rt" {
#  value = aws_ec2_transit_gateway_route_table.woznet
#}

resource "aws_ec2_transit_gateway_route" "last_resort" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
}

locals {
  map_custom_routes = {
    "woznet1" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc1.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet1.id
    }
    "woznet2" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc2.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
    }
    "woznet3" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc3.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet3.id
    }
    "woznet4" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc4.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet4.id
    }
  }
}

# 

#resource "aws_ec2_transit_gateway_route" "list_custom_routes" {
#  destination_cidr_block         = aws_vpc.woznet_vpc2.cidr_block
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
#  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
#}
#
#resource "aws_ec2_transit_gateway_route_table_association" "list_associations" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
#  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
#}

# map

resource "aws_ec2_transit_gateway_route" "custom_routes" {
  for_each = local.map_custom_routes

  destination_cidr_block         = each.value.destination_cidr_block[0]
  transit_gateway_attachment_id  = each.value["transit_gateway_attachment_id"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
}

resource "aws_ec2_transit_gateway_route_table_association" "associations" {
  for_each = local.map_custom_routes

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
}




