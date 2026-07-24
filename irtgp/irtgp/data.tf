data "aws_ec2_transit_gateway" "ashburn_tgw" {
  filter {
    name = "state"
    values = ["pendingAcceptance","available"]
  }
}

data "aws_ec2_transit_gateway" "london_tgw" {
  provider = aws.London

  filter {
    name = "state"
    values = ["pendingAcceptance","available"]
  }
}


data "aws_ec2_transit_gateway" "auckland_tgw" {
  provider = aws.Auckland

  filter {
    name = "state"
    values = ["pendingAcceptance","available"]
  }
}

