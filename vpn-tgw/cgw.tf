##############################################
#                                            #
# Just tell AWS the other end of the tunnel. #
#                                            #
##############################################

resource "aws_customer_gateway" "ToOurzoo" { 
  bgp_asn    = 65000 # the ASN for your DC VPN gateway
  ip_address = "172.125.57.137" # home.ourzoo.us
  type       = "ipsec.1"

  tags = {
    Name = "Ourzoo"
  }
}

