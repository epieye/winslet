

resource "aws_internet_gateway" "woznet_ingress_igw" {
  vpc_id = aws_vpc.woznet_ingress_vpc.id
  tags = {
    Name = "woznet-ingress-igw"
  }
}

resource "aws_internet_gateway" "woznet_egress_igw" {
  vpc_id = aws_vpc.woznet_egress_vpc.id
  tags = {
    Name = "woznet-egress-igw"
  }
}

