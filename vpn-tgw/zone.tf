#################################################
#                                               #
#                                               #
#                                               #
#################################################

resource "aws_route53_zone" "internal" {
  vpc {
    vpc_id  = aws_vpc.woznet_vpc1.id
  }
  vpc {
    vpc_id  = aws_vpc.woznet_vpc2.id
  }

  name    = "kinaida.net"
}

