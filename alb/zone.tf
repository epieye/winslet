# Public kinaida.net is permanent. This is supposed to be the private zone.

resource "aws_route53_zone" "internal" {
  vpc {
    vpc_id  = aws_vpc.woznet_vpc.id
  }
  name    = "kinaida.net"
}

