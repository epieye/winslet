/*
  Create EC2s so I can access the EKS cluster. If it even works like that.
*/

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

data "template_file" "user_data" {
  template = file("user_data.sh")
}

module "lbnet_sg" {
  source = "../modules/security_group"

  vpc_id = module.lbnet.vpc_id

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "lbnet_sg"
    }
  )
}

// Move private instances to autoscaling 
module "lbnet_ec2_1" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = module.lbnet.private_subnet_ids[0]
  user_data = data.template_file.user_data.rendered  # Why isn't user_data getting run? Perhaps private?
  public_ip = false

  disk_size = 100

  vpc_sec_group = module.lbnet_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "lbnet_ec2_1"
    }
  )
}

module "lbnet_ec2_2" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = module.lbnet.private_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = false

  disk_size = 100

  vpc_sec_group = module.lbnet_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "lbnet_ec2_2"
    }
  )
}

// 
module "lbnet_bastion" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = module.lbnet.public_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.lbnet_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "lbnet_ec2_jump"
    }
  )
}

#// Additional network interface
#resource "aws_network_interface" "test" {
#  subnet_id       = module.lbnet.public_subnet_ids[0] # resource "aws_subnet" "private_subnet1"
#  private_ips     = ["192.168.7.10"]
#  security_groups = [module.lbnet_sg.id]
#
#  #attachment {
#  #  instance     = module.lbnet_bastion.instance_id
#  #  device_index = 1
#  #}
#}

## attach the additional network interface
#resource "aws_network_interface_attachment" "test" {
#  instance_id          = module.lbnet_bastion.id       <- what is it if it's not id?
#  network_interface_id = aws_network_interface.test.id
#  device_index         = 1
#}

#output "tgw_id" {
#  value = module.transit_gateway.id
#}

#output "lbnet_tgw_attach_id" {
#  value = module.lbnet_tgw_attachment.id
#}

#output "lbnet_vpc_id" {
#  value = module.lbnet.vpc_id
#}

#output "lbnet_public_address" {
#  value = module.lbnet_ec2.public_ip
#}

output "lbnet_bastion_public_ip" {
  value = module.lbnet_bastion.module_ec2.public_ip
}

output "lbnet_bastion_id" {
  value = module.lbnet_bastion.module_ec2.id
}

#output "lbnet_private_ip" {
#  value = module.lbnet_ec2.module_ec2.private_ip
#}


#output "lbnet_ec2_1" {
#  value = module.lbnet_ec2_1.host_id
#}

#output "lbnet_ec2_2" {
#  value = module.lbnet_ec2_2.private_ip
#}

#output "lbnet_sg" {
#  value = module.lbnet_sg
#}

