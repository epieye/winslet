resource "aws_customer_gateway" "ToAzureInstance0" {
  bgp_asn    = 65000
  ip_address = azurerm_public_ip.VNet1GWpip1.ip_address
  type       = "ipsec.1"
  #depends_on = [ azurerm_public_ip.VNet1GWpip1 ]

  tags = {
    Name = "gatius"
  }
}

resource "aws_customer_gateway" "ToAzureInstance1" {
  bgp_asn    = 65000 # the ASN for your Azure VPN gateway
  ip_address = azurerm_public_ip.VNet1GWpip2.ip_address
  type       = "ipsec.1"
  #depends_on = [ azurerm_public_ip.VNet1GWpip2 ]

  tags = {
    Name = "oglethorpe"
  }
}
