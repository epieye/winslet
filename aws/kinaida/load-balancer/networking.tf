module "kinaida-lbnet" {
  source = "../../modules/vpc"

  base_cidr_block = "192.168.128.0/24"
  internet_gateway = true

  tags = merge(
    module.configuration.tags,
    {
      Name = "kinaida-lbnet"  
    }
  )
}

