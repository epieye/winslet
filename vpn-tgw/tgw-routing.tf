#
#
# All VPCs should route all non-local traffic to the TGW, except the subnets connected to the NAT Gateways. #
# I guess the VPN attachement too. 
#

resource "aws_ec2_transit_gateway_route_table" "woznet" {
  transit_gateway_id = aws_ec2_transit_gateway.woznet-tg.id
}

resource "aws_ec2_transit_gateway_route" "last_resort" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.woznet.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.woznet.id
}

locals {
  map_custom_routes = {
    "woznet1" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc1.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet.id
    }
    "woznet2" = {
      destination_cidr_block        = [aws_vpc.woznet_vpc2.cidr_block]
      transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.woznet2.id
    }
    "vpn" = {
      destination_cidr_block        = ["192.168.0.0/16"]
      transit_gateway_attachment_id = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
    }
  }
}

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



