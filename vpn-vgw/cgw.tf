##############################################
#                                            #
# Just tell AWS the other end of the tunnel. #
#                                            #
##############################################

resource "aws_customer_gateway" "ToOurzoo" { #  change to Ourzoo CG (FG)
  bgp_asn    = 65000 # the ASN for your DC VPN gateway
  ip_address = "172.125.57.137"
  type       = "ipsec.1"

  tags = {
    Name = "Ourzoo"
  }
}

