## The local requests the peering to the remote, is that right?
#
#resource "aws_ec2_transit_gateway_peering_attachment" "ashburn_requester" {
#  transit_gateway_id = data.aws_ec2_transit_gateway.ashburn_tgw.id
#  peer_transit_gateway_id = data.aws_ec2_transit_gateway.auckland_tgw.id
#  peer_account_id         = data.aws_ec2_transit_gateway.auckland_tgw.owner_id
#  peer_region             = data.aws_ec2_transit_gateway.auckland_tgw.region
#
#  # │ Error: creating EC2 Transit Gateway Peering Attachment: operation error EC2: CreateTransitGatewayPeeringAttachment, https response error StatusCode: 400, RequestID: 98388861-f868-4948-831f-56cbfc61e5a0, api error DuplicateTransitGatewayAttachment: tgw-019839bd63165b458 has a non-deleted Transit Gateway Peering Attachment with tgw-0e001099908245991.
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
#resource "aws_ec2_transit_gateway_peering_attachment_accepter" "auckland_accepter" {
#  provider = aws.Auckland
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn.id
#
#  tags = {
#    Name = "remote-to-local-peering-accepter"
#  }
#}
#
#
## Associate the attachment to the routing table in each region
#
#resource "aws_ec2_transit_gateway_route_table_association" "local-ashburn-tg-rtb" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ashburn_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route_table_association" "remote-auckland-tg-rtb" {
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
### London is 192.168.8.0/22 and 10.0.8.0/22
##resource "aws_ec2_transit_gateway_route" "local_to_remote_route" {
##  destination_cidr_block         = "192.168.8.0/22"
##  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
##  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
##}
##resource "aws_ec2_transit_gateway_route" "local_to_remote_route-2" {
##  destination_cidr_block         = "10.0.8.0/22"
##  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
##  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
##}
#
## Ashburn is 192.168.12.0/22 and 10.0.12.0/22
#resource "aws_ec2_transit_gateway_route" "remote_auckland_to_local_ashburn_route" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "192.168.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.auckland_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route" "remote_auckland_to_local_ashburn_route_2" {
#  provider                       = aws.Auckland
#  destination_cidr_block         = "10.0.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.auckland_accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
#}
#
#
## Auckland is 192.168.4.0/22 and 10.0.4.0/22
#
#resource "aws_ec2_transit_gateway_route" "local_ashburn_to_remote_auckland_route" {
#  destination_cidr_block         = "192.168.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#resource "aws_ec2_transit_gateway_route" "local_ashburn_to_remote_auckland_route_2" {
#  destination_cidr_block         = "10.0.4.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#
#
#
