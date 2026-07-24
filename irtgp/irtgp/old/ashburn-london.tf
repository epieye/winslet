## The local requests the peering to the remote, is that right?
#resource "aws_ec2_transit_gateway_peering_attachment" "ashburn_london_requester" {
#  transit_gateway_id = data.aws_ec2_transit_gateway.local_ashburn_tgw.id
#  peer_transit_gateway_id = data.aws_ec2_transit_gateway.remote_london_tgw.id
#  peer_account_id         = data.aws_ec2_transit_gateway.remote_london_tgw.owner_id
#  peer_region             = data.aws_ec2_transit_gateway.remote_london_tgw.region
#
#  tags = {
#    Name = "local-to-remote-peering"
#  }
#}
#
## And the remote accepts the connection, right?
#resource "aws_ec2_transit_gateway_peering_attachment_accepter" "ashburn_london_accepter" {
#  provider = aws.Auckland
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id
#
#  tags = {
#    Name = "remote-to-local-peering-accepter"
#  }
#}
#
## Associate the attachment to the routing table in each region
#resource "aws_ec2_transit_gateway_route_table_association" "london-local-ashburn-tg-rtb" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route_table_association" "auckland_routes_remote_london_tg_rtb" {
#  provider = aws.Auckland
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
## Lastly the routing. I need the remote CIDRs in the local table. And the local CIDRs in the remote table.
### London is 192.168.8.0/22 and 10.0.8.0/22
#
## Ashburn is 192.168.12.0/22 and 10.0.12.0/22
#resource "aws_ec2_transit_gateway_route" "remote_london_to_local_ashburn_route" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "192.168.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route" "remote_london_to_local_ashburn_route_2" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "10.0.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
## Auckland is 192.168.4.0/22 and 10.0.4.0/22
#resource "aws_ec2_transit_gateway_route" "local_ashburn_to_remote_london_route" {
#  destination_cidr_block         = "192.168.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#resource "aws_ec2_transit_gateway_route" "local_ashburn_to_remote_london_route_2" {
#  destination_cidr_block         = "10.0.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
