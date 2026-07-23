resource "aws_vpc" "woznet_kinaida_vpc" {
  cidr_block = "192.168.0.0/20"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  assign_generated_ipv6_cidr_block = false
    
  tags = {
    Name = "kinaida-vpc"
  }

  provider = aws.kinaida
}

