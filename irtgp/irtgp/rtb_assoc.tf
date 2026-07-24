

# Ashburn-London Requester. Associate Ashburn-London-Requester transit gateway attachment to Ashburn Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "ashburn-london-requester-tg-rtb" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester]
  # perhaps wait_for_steady_state = true <- actually in peering_attachment.tf
}

# Ashburn-London Accepter. Associate Ashburn-London-Accepter transit gateway attachment to London Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "ashburn-london-accepter-tg-rtb" {
  provider = aws.London
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_london_accepter]
}

# Ashburn-Auckland Requester. Associate Ashburn-Auckland-Requester transit gateway attachment to Ashburn Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "ashburn-auckland-requester-tg-rtb" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ashburn_auckland_requester.id
  transit_gateway_route_table_id = data.terraform_remote_state.ashburn.outputs.tg-rtb-id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.ashburn_auckland_requester]
}

# Ashburn Auckland Acceptor. Associate Ashburn-Auckland transit gateway attachment to Auckland Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "ashburn-auckland-accepter-tg-rtb" {
  provider = aws.Auckland
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.ashburn_auckland_accepter]
}

#London-Auckland Requester. Associate London-Auckland-Requester transit gateway attachment to London Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "london-auckland-requester-tg-rtb" {
  provider = aws.London
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.london_auckland_requester.id
  transit_gateway_route_table_id = data.terraform_remote_state.london.outputs.tg-rtb-id

  depends_on = [aws_ec2_transit_gateway_peering_attachment.london_auckland_requester]
}

#London Auckland Acceptor. Associate London-Auckland-Acceptor transit gateway attachment to Auckland Routing Table.
resource "aws_ec2_transit_gateway_route_table_association" "london-auckland-acceptor-tg-rtb" {
  provider = aws.Auckland
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter.id
  transit_gateway_route_table_id = data.terraform_remote_state.auckland.outputs.tg-rtb-id
 
  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.london_auckland_accepter]
}

