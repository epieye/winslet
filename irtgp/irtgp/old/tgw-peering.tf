## Data source to fetch the local TGW ID. Ashburn is the default provider.
#data "aws_ec2_transit_gateway" "local_tgw" {
#  filter {
#    name = "state"
#    values = ["pendingAcceptance","available"]
#  }
#}
#
#output "local_tgw" {
#  value = data.aws_ec2_transit_gateway.local_tgw
#}
#
#data "aws_ec2_transit_gateway" "remote_tgw" {
#  provider = aws.London
#
#  filter {
#    name = "state"
#    values = ["pendingAcceptance","available"]
#  }
#}
#
##output "remote_tgw" {
##  value = data.aws_ec2_transit_gateway.remote_tgw
##}
#
#
###data "aws_region" "peer3" {
###  provider = aws.Melbourne
###}
#
##data "aws_region" "peer4" {
##  provider = aws.Auckland
##}
#
##data "aws_ec2_transit_gateway" "remote_tgw" {
##  provider = aws.london
##}
#
#output "london-tgw" {
#  value = data.aws_ec2_transit_gateway.remote_tgw
#}
#
##resource "aws_ec2_transit_gateway" "local" {
##  provider = aws.Ashburn
##
##  tags = {
##    Name = "Local TGW"
##  }
##}
#
####resource "aws_ec2_transit_gateway" "peer1" {
####  provider = aws.Capetown
####
####  tags = {
####    Name = "Peer TGW"
####  }
####}
####
####output "peer1" {
####  values = data.aws_region.peer1
####}
#
##resource "aws_ec2_transit_gateway" "peer2" {
##  provider = aws.London
##
##  tags = {
##    Name = "Peer TGW"
##  }
##}
#
####resource "aws_ec2_transit_gateway" "peer3" {
####  provider = aws.Melbourne
####
####  tags = {
####    Name = "Peer TGW"
####  }
####}
#
#
#
#
#
#data "aws_ec2_transit_gateway" "remote2_tgw" {
#  provider = aws.Auckland
#
#  filter {
#    name = "state"
#    values = ["pendingAcceptance","available"]
#  }
#}
#
#output "auckland-tgw" {
#  value = data.aws_ec2_transit_gateway.remote2_tgw
#}
#
#
#
#
#
#
#
#
#
#
#
#
#resource "aws_ec2_transit_gateway_peering_attachment" "requester" {
#  transit_gateway_id = data.aws_ec2_transit_gateway.local_tgw.id
#  peer_transit_gateway_id = data.aws_ec2_transit_gateway.remote_tgw.id
#  peer_account_id         = data.aws_ec2_transit_gateway.remote_tgw.owner_id
#  peer_region             = data.aws_ec2_transit_gateway.remote_tgw.region
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
#
#
#
#
#
#
####resource "aws_ec2_transit_gateway_peering_attachment" "Capetown" {
####  peer_account_id         = aws_ec2_transit_gateway.peer1.owner_id
####  peer_region             = data.aws_region.peer1.region
####  peer_transit_gateway_id = aws_ec2_transit_gateway.peer1.id
####  transit_gateway_id      = aws_ec2_transit_gateway.local.id
####
####  tags = {
####    Name = "TGW Peering Requestor"
####  }
####}
#
### Use the aws_ec2_transit_gateway_peering_attachment resource in 
### the requester region to initiate the peering request. You must 
### reference the peer TGW's ID and region. 
##resource "aws_ec2_transit_gateway_peering_attachment" "London" {
##  provider                = aws.Asbburn # 
##  peer_account_id         = aws_ec2_transit_gateway.peer2.owner_id
##  peer_region             = data.aws_region.peer2.region
##  peer_transit_gateway_id = aws_ec2_transit_gateway.peer2.id
##  transit_gateway_id      = aws_ec2_transit_gateway.local.id
##
##  tags = {
##    Name = "TGW Peering Requestor"
##  }
##}
##
####resource "aws_ec2_transit_gateway_peering_attachment" "Melbourne" {
####  peer_account_id         = aws_ec2_transit_gateway.peer3.owner_id
####  peer_region             = data.aws_region.peer3.region
####  peer_transit_gateway_id = aws_ec2_transit_gateway.peer3.id
####  transit_gateway_id      = aws_ec2_transit_gateway.local.id
####
####  tags = {
####    Name = "TGW Peering Requestor"
####  }
####}
#
#
#resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accepter" {
#  provider = aws.London
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
#
#  tags = {
#    Name = "remote-to-local-peering-accepter"
#  }
#}
#
#
## Surely I need to associate the attachment with the transit gateway routing table.
##resource "aws_route_table_association" "local-tg-rtb" {
##  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.accepter.id
##  route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
##}
##
##resource "aws_route_table_association" "remote-tg-rtb" {
##  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
##  route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
##}
#
#resource "aws_ec2_transit_gateway_route_table_association" "local-tg-rtb" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#
## Is it failing because it is in a region other than the default? the tg_rtb_id does not exist in Ashburn.
#resource "aws_ec2_transit_gateway_route_table_association" "remote-tg-rtb" {
#  provider = aws.London
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
## also Auckland
#
#
## London is 192.168.8.0/22 and 10.0.8.0/22
#resource "aws_ec2_transit_gateway_route" "local_to_remote_route" {
#  destination_cidr_block         = "192.168.8.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#resource "aws_ec2_transit_gateway_route" "local_to_remote_route-2" {
#  destination_cidr_block         = "10.0.8.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.requester.id
#  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id
#}
#
## Ashburn is 192.168.12.0/22 and 10.0.12.0/22
#resource "aws_ec2_transit_gateway_route" "remote_to_local_route" {
#  provider                       = aws.London
#  destination_cidr_block         = "192.168.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
#resource "aws_ec2_transit_gateway_route" "remote_to_local_route-2" {
#  provider                       = aws.London
#  destination_cidr_block         = "10.0.12.0/22"
#  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.accepter.id
#  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id
#}
#
#
#
#
#
