#################################################
#                                               #
# kinaida.net is permanent.                     #
# create internal zones                         #
# Add resolver.                                 #
# Should I create in other accounts?            #
# I don't think I need to, just other VPCs.     #
# I'll have ourzoo.us once I move it to Amazon. #
# In Azure too eventually.                      #
#                                               #
#################################################

# 
resource "aws_route53_zone" "internal" {
  vpc {
    vpc_id  = aws_vpc.woznet_vpc1.id
  }
  #vpc {
  #  vpc_id  = aws_vpc.woznet_vpc2.id
  #}
  name    = "internal.kinaida.net"
}

resource "aws_route53_zone" "        " {
  #vpc {
  #  vpc_id  = aws_vpc.woznet_vpc1.id
  #}
  vpc {
    vpc_id  = aws_vpc.woznet_vpc2.id
  }
  name    = "        .kinaida.net"
}

# I'll have ourzoo.us once I move it to Amazon. 

## eu-west?
#resource "aws_route53_zone" "        " {
#  vpc {
#    vpc_id  = aws_vpc.woznet_vpc1.id
#  }
#  vpc {
#    vpc_id  = aws_vpc.woznet_vpc2.id
#  }
#  name    = "europe.kinaida.net"
#}
#
# ourzoo.kinaida.net
# 
