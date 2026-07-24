# ---Ashburn to London

resource "aws_ec2_transit_gateway_peering_attachment" "ashburn_london_requester" {
  transit_gateway_id = data.aws_ec2_transit_gateway.ashburn_tgw.id
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.london_tgw.id
  peer_account_id         = data.aws_ec2_transit_gateway.london_tgw.owner_id
  peer_region             = data.aws_ec2_transit_gateway.london_tgw.region

  #wait_for_steady_state = true

  need a wait for the correct state.


  tags = {
    Name = "Ashburn-to-London-Requester"
  }
}

# And the remote accepts the connection, right?
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "ashburn_london_accepter" {
  provider = aws.London
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_london_requester.id

  #wait_for_steady_state = true

  tags = {
    Name = "Ashburn-to-London-Accepter"
  }
}

# ---Ashburn to Auckland

resource "aws_ec2_transit_gateway_peering_attachment" "ashburn_auckland_requester" {
  transit_gateway_id = data.aws_ec2_transit_gateway.ashburn_tgw.id
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.auckland_tgw.id
  peer_account_id         = data.aws_ec2_transit_gateway.auckland_tgw.owner_id
  peer_region             = data.aws_ec2_transit_gateway.auckland_tgw.region
 
  tags = {
    Name = "Ashburn-to-Auckland-Requester"
  }
}
 
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "ashburn_auckland_accepter" {
  provider = aws.Auckland
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ashburn_auckland_requester.id
 
  tags = {
    Name = "Ashburn-to-Auckland-Accepter"
  }
}

# ---London to Auckland

resource "aws_ec2_transit_gateway_peering_attachment" "london_auckland_requester" {
  provider = aws.London
  transit_gateway_id = data.aws_ec2_transit_gateway.london_tgw.id
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.auckland_tgw.id
  peer_account_id         = data.aws_ec2_transit_gateway.auckland_tgw.owner_id
  peer_region             = data.aws_ec2_transit_gateway.auckland_tgw.region
 
  tags = {
    Name = "London-to-Auckland-Requester"
  }
}
 
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "london_auckland_accepter" {
  provider = aws.Auckland
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.london_auckland_requester.id

  tags = {
    Name = "London-to-Auckland-Accepter"
  }
}


 
