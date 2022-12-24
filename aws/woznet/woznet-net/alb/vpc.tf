module "vanuatu" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.7.0/24"
  #assign_generated_ipv6_cidr_block = false
  internet_gateway = true

  #custom_private_routes = [
  #  {
  #    destination_cidr_block = "192.168.4.0/22"
  #    transit_gateway_id = module.transit_gateway.id
  #  }
  #]

  tags = merge(
    module.configuration.tags,
    {
      Name = "vanuatu"
    }
  )
}



# subnets 
# routing table

output "vanuatu" {
  value = module.vanuatu
}

