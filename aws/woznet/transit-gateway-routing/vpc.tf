/*
   Woznet
   Create VPCs and TGW for inter-VPC routing.
*/

module "woznet" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.4.0/22" # Allocate a VPC within Woznet
  #assign_generated_ipv6_cidr_block = false
  internet_gateway = true

  # don't forget we want 3 AZs for Kubernetes

  custom_private_routes = [
    {
      destination_cidr_block = "192.168.4.0/22"
      transit_gateway_id = module.transit_gateway.id
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "woznet"
    }
  )
}

module "woznet_spew" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.192.0/22" # Allocate a VPC within Woznet-Spew
  internet_gateway = false

  # don't forget we want 3 AZs for Kubernetes

  #custom_private_routes = [
  #  {
  #    destination_cidr_block = "192.168.4.0/22"
  #    transit_gateway_id = module.transit_gateway.id
  #  }
  #]

  tags = merge(
    module.configuration.tags,
    {
      Name = "woznet_spew"
    }
  )
}

## create additional cidr in vpc before adding additional subnets
#resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#  vpc_id     = module.woznet.vpc_id
#  cidr_block = "192.168.7.0/24"
#}

module "woznet_tgw_attachment" {
  source = "../../modules/transit_gateway_attachment"

  subnet_ids = module.woznet.private_subnet_ids
  vpc_id = module.woznet.vpc_id
  transit_gateway_id = module.transit_gateway.id

  tags = merge(
    module.configuration.tags,
    {
      Name = "Woznet-attach"
    }
  )
}

module "transit_gateway" {
  source = "../../modules/transit_gateway"
  asn = 65533

  #custom_routes = [
  #  {
  #    destination_cidr_block = "192.168.0.0/18"   # don't hard code. module.woznet.base_cidr_block
  #    transit_gateway_attachment_id = module.woznet_tgw_attachment.id
  #  },
  #  #{
  #  #  destination_cidr_block = "192.168.5.0/24"
  #  #  transit_gateway_attachment_id = data.terraform_remote_state.ourzoo.ourzoo_tgw_attachment.id
  #  #},
  #  #{
  #  #  destination_cidr_block = "192.168.6.0/24"
  #  #  transit_gateway_attachment_id = data.terraform_remote_state.kinaida.kinaida_tgw_attachment.id
  #  #},
  #  #{
  #  #  destination_cidr_block = "192.168.7.0/24"
  #  #  transit_gateway_attachment_id = data.terraform_remote_state.woznet.woznet_tgw_attachment.id
  #  #}
  #]

  tags = merge(
    module.configuration.tags,
    {
      Name = "Wozgate"
    }
  )
}

## Create additional subnets in inpection VPC for VPN portal on PA NGFW.
#resource "aws_subnet" "private_subnet1" {
#  vpc_id = module.woznet.vpc_id
#  count = "1"
#  cidr_block = "192.168.7.0/25"
#  availability_zone = "us-east-1a"
#
#  map_public_ip_on_launch = false
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "vpn1-portal-subnet-private-us-east-1a"
#    }
#  )
#}

#resource "aws_subnet" "private_subnet2" {
#  vpc_id = module.woznet.vpc_id
#  count = "1"
#  cidr_block = "192.168.7.128/25"
#  availability_zone = "us-east-1b"
#
#  map_public_ip_on_launch = false
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "vpn2-portal-subnet-private-us-east-1b"
#    }
#  )
#}

output "tgw_id" {
  value = module.transit_gateway.id
}

output "woznet_tgw_attach_id" {
  value = module.woznet_tgw_attachment.id
}

output "woznet_vpc_id" {
  value = module.woznet.vpc_id
}

#output "tgw_id" {
#  value = module.transit_gateway.id
#}

#output "woznet_tgw_attach_id" {
#  value = module.woznet_tgw_attachment.id
#}

#output "woznet_vpc_id" {
#  value = module.woznet.vpc_id
#}

#output "woznet_public_address" {
#  value = module.woznet_ec2
#}

output "woznet_settings" {
  value = module.woznet
}
