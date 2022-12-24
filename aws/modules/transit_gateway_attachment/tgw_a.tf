locals {
  custom_routes = flatten([
    for obj in var.custom_routes : [
      for cidr in obj.destination_cidr_block : {
        destination_cidr_block   = cidr
        transit_gateway_attachment_id = obj.transit_gateway_attachment_id
      }
    ]
  ])
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attachment" {
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  transit_gateway_default_route_table_association = var.default_association
  transit_gateway_default_route_table_propagation = var.default_propagation
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-tgwa"
    }
  )
}

resource "aws_ec2_transit_gateway_route_table" "rtb" {
  count = var.default_association == false && length(local.custom_routes) > 0 ? 1 : 0  
  transit_gateway_id = var.transit_gateway_id
}

resource "aws_ec2_transit_gateway_route" "route" {
  count = var.default_association == false && length(local.custom_routes) > 0 ? length(local.custom_routes) : 0  
  destination_cidr_block         = lookup(local.custom_routes[count.index], "destination_cidr_block", null)
  transit_gateway_attachment_id  = lookup(local.custom_routes[count.index], "transit_gateway_attachment_id", null)
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc" {
  count = var.default_association == false && length(local.custom_routes) > 0 ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb[0].id
}

output "id" {
  value = aws_ec2_transit_gateway_vpc_attachment.attachment.id
}