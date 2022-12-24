module "lbnet" {
  source = "../modules/vpc"

  base_cidr_block = "192.168.9.0/24"
  internet_gateway = true

  tags = merge(
    module.configuration.tags,
    {
      Name = "lbnet"  
    }
  )
}

