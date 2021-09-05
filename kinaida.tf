/*
   Kinaida
   Create VPCs and TGW for inter-VPC routing.
*/

module "kinaida" {
  source = "./modules/vpc"

  base_cidr_block = "192.168.2.0/24"
  internet_gateway = true

  # don't forget we want 3 AZs for Kubernetes

  custom_private_routes = [
    {
      destination_cidr_block = "192.168.0.0/16"
      transit_gateway_id = module.transit_gateway.id
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "kinaida"
    }
  )
}

module "kinaida_tgw_attachment" {
  source = "./modules/transit_gateway_attachment"

  subnet_ids = module.kinaida.private_subnet_ids
  vpc_id = module.kinaida.vpc_id
  transit_gateway_id = module.transit_gateway.id

  tags = merge(
    module.configuration.tags,
    {
      Name = "Kinaida-attach"
    }
  )
}

module "kinaida_sg" {
  source = "./modules/security_group"

  vpc_id = module.kinaida.vpc_id

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    #  from_port  = 514
    #  to_port = 514
    #  protocol = "udp"
    #  cidr_blocks = ["0.0.0.0/0"]
    #}
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "kinaida-sg"
    }
  )
}

// 
module "kinaida_ec2" {
  source = "./modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Monaco"
  subnet_id = module.kinaida.private_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.kinaida_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "kinaida_ec2"
    }
  )
}

#outputs

output "kindaida_tgw_attach_id" {
  value = module.kinaida_tgw_attachment.id
}

output "kinaida_vpc_id" {
  value = module.woznet.vpc_id
}
