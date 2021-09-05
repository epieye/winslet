/*
   Woznet
   Create VPCs and TGW for inter-VPC routing.
*/

module "woznet" {
  source = "./modules/vpc"

  base_cidr_block = "192.168.0.0/24"
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
      Name = "woznet"
    }
  )
}

module "woznet_tgw_attachment" {
  source = "./modules/transit_gateway_attachment"

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
  source = "./modules/transit_gateway"
  
  asn = 65533

  custom_routes = [
    {
      destination_cidr_block = "192.168.0.0/24"
      transit_gateway_attachment_id = module.woznet_tgw_attachment.id
    },
    {
      destination_cidr_block = "192.168.1.0/24"
      transit_gateway_attachment_id = module.ourzoo_tgw_attachment.id
    },
    {
      destination_cidr_block = "192.168.2.0/24"
      transit_gateway_attachment_id = module.kinaida_tgw_attachment.id
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "Wozgate"
    }
  )
}

#output "tgw_id" {
#  value = module.transit_gateway.id
#}
#
#output "woznet_tgw_attach_id" {
#  value = module.woznet_tgw_attachment.id
#}
#
#output "woznet_vpc_id" {
#  value = module.woznet.vpc_id
#}

/*
  Create and EC2 so I can access the EKS cluster. If it even works like that.
*/

// Thanks Steve.
data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*.*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

#variable "woznet-instance-name" {
#    default="woznet"
#}
#
#variable "ourzoo-instance-name" {
#    default="ourzoo"
#}
#
#variable "kinaida-instance-name" {
#    default="kinaida"
#}

data "template_file" "user_data" {
  template = file("user_data.sh")
}

module "woznet_sg" {
  source = "./modules/security_group"

  vpc_id = module.woznet.vpc_id

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "woznet-sg"
    }
  )
}

// 
module "woznet_ec2" {
  source = "./modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Monaco"
  subnet_id = module.woznet.private_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.woznet_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "woznet_ec2"
    }
  )
}

// 
module "woznet_bastion" {
  source = "./modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Monaco"
  subnet_id = module.woznet.public_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.woznet_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "woznet_ec2_jump"
    }
  )
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
#  value = module.woznet_ec2.public_ip
#}

#output "woznet_settings" {
#  value = module.woznet
#}
