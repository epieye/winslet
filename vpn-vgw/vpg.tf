#
#
# This will use the default ASN 64512
#
#

resource "aws_vpn_gateway" "woznet_vpn_gw" {
  vpc_id = aws_vpc.woznet_vpc.id

  tags = {
    Name = "woznet_vpn_gw"
  }
}
