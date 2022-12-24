resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments = "enable"
  amazon_side_asn = var.asn
  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-tgw-1"
    }
  )
}

resource "aws_ec2_transit_gateway_route" "example" {
  count = length(var.custom_routes)
  destination_cidr_block         = lookup(var.custom_routes[count.index], "destination_cidr_block", null)
  transit_gateway_attachment_id  = lookup(var.custom_routes[count.index], "transit_gateway_attachment_id", null)
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}


output "id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "arn" {
  value = aws_ec2_transit_gateway.tgw.arn
}

output "rtb" {
  value = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}

