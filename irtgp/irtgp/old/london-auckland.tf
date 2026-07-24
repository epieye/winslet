#data "aws_ec2_transit_gateway" "local_london_tgw" {
#  filter {
#    name = "state"
#    values = ["pendingAcceptance","available"]
#  }
#}
#
#data "aws_ec2_transit_gateway" "remote_auckland_tgw" {
#  provider = aws.Auckland
#
#  filter {
#    name = "state"
#    values = ["pendingAcceptance","available"]
#  }
#}
#
## The local requests the peering to the remote, is that right?
#
#resource "aws_ec2_transit_gateway_peering_attachment" "london_requester" {
#  transit_gateway_id = data.aws_ec2_transit_gateway.local_london_tgw.id
#  peer_transit_gateway_id = data.aws_ec2_transit_gateway.remote_auckland_tgw.id
#  peer_account_id         = data.aws_ec2_transit_gateway.remote_auckland_tgw.owner_id
#  peer_region             = data.aws_ec2_transit_gateway.remote_auckland_tgw.region
#
#  tags = {
#    Name = "local-to-remote-peering"
#  }
#}
#
#
#
#
#
## And the remote accepts the connection, right?
#
#resource "aws_ec2_transit_gateway_peering_attachment_accepter" "london_requester_auckland_accepter" {
#  provider = aws.Auckland
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_requester.id
#
#  tags = {
#    Name = "remote-to-local-peering-accepter"
#  }
#}
#
#
## Associate the attachment to the routing table in each region. Is this the bit that needs a delay?
#
#resource "aws_ec2_transit_gateway_route_table_association" "local-london-tg-rtb" {
#  provider = aws.London
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#
#  # │ Error: creating EC2 Transit Gateway Route Table Association (tgw-rtb-03099bc0525e4a850_tgw-attach-0a15db8d53856bcf0): operation error EC2: AssociateTransitGatewayRouteTable, https response error StatusCode: 400, RequestID: e8e83aab-f862-4e8c-8502-06b3109d1847, api error InvalidTransitGatewayAttachmentID.NotFound: Transit Gateway Attachment tgw-attach-0a15db8d53856bcf0 was deleted or does not exist.
#}
#
#resource "aws_ec2_transit_gateway_route_table_association" "london-remote-auckland-tg-rtb" {
#  provider = aws.Auckland
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.auckland_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
#}
#
#
#
#
## Lastly the routing. I need the remote CIDRs in the local table. And the local CIDRs in the remote table.
#
## London is 192.168.8.0/22 and 10.0.8.0/22
#
#resource "aws_ec2_transit_gateway_route" "remote_auckland_to_local_london_route" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "192.168.8.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.auckland_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route" "remote_auckland_to_local_london_route_2" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "10.0.8.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.auckland_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
#}
#
#
## Auckland is 192.168.4.0/22 and 10.0.4.0/22
#
#resource "aws_ec2_transit_gateway_route" "local_london_to_remote_auckland_route" {
#  provider                       = aws.London
#  destination_cidr_block         = "192.168.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#resource "aws_ec2_transit_gateway_route" "local_london_to_remote_auckland_route_2" {
#  provider                       = aws.London
#  destination_cidr_block         = "10.0.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
#
#
