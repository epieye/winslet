
resource "aws_vpc" "woznet_vpc1" {
  cidr_block = "10.0.128.0/22"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "woznet-vpc1"
  }
}

resource "aws_vpc" "woznet_vpc2" {
  cidr_block = "10.0.132.0/22"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "woznet-vpc2"
  }
}


