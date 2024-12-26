

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = aws_vpc.woznet_vpc1.id
  vpc_id        = aws_vpc.woznet_vpc2.id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
