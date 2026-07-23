#
#
# For NAT GWs
#
#

resource "aws_eip" "woznet-eip-a" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-a"
  }
}

resource "aws_eip" "woznet-eip-b" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-b"
  }
}
