
## Lastly the routing. I need the remote CIDRs in the local table. And the local CIDRs in the remote table.
# Auckland is 192.168.4.0/22  and 10.0.4.0/22
# London   is 192.168.8.0/22  and 10.0.8.0/22
# Ashburn  is 192.168.12.0/22 and 10.0.12.0/22


# Add London and Auckland CIDRs to Ashburn.

resource "aws_ec2_transit_gateway_route" "london_from_ashburn_route1" {
  destination_cidr_block         = "192.168.8.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "london_from_ashburn_route2" {
  destination_cidr_block         = "10.0.8.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "auckland_from_ashburn_route1" {
  destination_cidr_block         = "192.168.4.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "auckland_from_ashburn_route2" {
  destination_cidr_block         = "10.0.4.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
}


# Add Ashburn and Auckland CIDRs to London

resource "aws_ec2_transit_gateway_route" "ashburn_from_london_route1" {
  provider = aws.London
  destination_cidr_block         = "192.168.12.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "ashburn_from_london_route2" {
  provider = aws.London
  destination_cidr_block         = "10.0.12.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "auckland_from_london_route1" {
  provider = aws.London
  destination_cidr_block         = "192.168.4.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "auckland_from_london_route2" {
  provider = aws.London
  destination_cidr_block         = "10.0.4.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
}






# Add Ashburn and London CIDRs to Auckland

resource "aws_ec2_transit_gateway_route" "ashburn_from_auckland_route1" {
  provider = aws.Auckland
  destination_cidr_block         = "192.168.12.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "ashburn_from_auckland_route2" {
  provider = aws.Auckland
  destination_cidr_block         = "10.0.12.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "london_from_auckland_route1" {
  provider = aws.Auckland
  destination_cidr_block         = "192.168.8.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
}

resource "aws_ec2_transit_gateway_route" "london_from_auckland_route2" {
  provider = aws.Auckland
  destination_cidr_block         = "10.0.8.0/22"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
}

