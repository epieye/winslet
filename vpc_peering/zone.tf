#################################################
#                                               #
# public kinaida.net is permanent.              #
# create internal zones                         #
# Add resolver. See ../resolver/                #
#                                               #
#################################################

# How do I add a VPC after the fact. I don't recall adding them all to the zone. Or is the resolver different?




# public kinaida.net is permanent. # But I'll create a public onedatascan.io. So create private kinaida.net when I have the resolver.
#resource "aws_route53_zone" "private_top_level_zone" {
#  vpc {
#    vpc_id  = aws_vpc.woznet_vpc1.id
#  }
#
#  name    = "kinaida.net"
#}

# Public kinaida.net is permanent. This is supposed to be the private zone.
resource "aws_route53_zone" "internal" {
  vpc {
    vpc_id  = aws_vpc.woznet_vpc1.id
  }
  vpc {
    vpc_id  = aws_vpc.woznet_vpc2.id
  }
  name    = "internal.kinaida.net"
}

