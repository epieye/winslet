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

data "template_file" "user_data" {
  template = file("user_data.sh")
}

module "woznet_sg" {
  source = "../modules/security_group"

  vpc_id = module.woznet.vpc_id

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port  = 0
      to_port = 443
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
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  #ami_id = "ami-08608909a95a943c5"
  key_name  = "Toulon"
  subnet_id = module.woznet.private_subnet_ids[0]
  #subnet_id = data.terraform_remote_state.woznet.private_subnet_ids[0]
  #subnet_id = "subnet-0b2008cdd9af45839"
  user_data = data.template_file.user_data.rendered
  public_ip = true

  disk_size = 100

  vpc_sec_group = module.woznet_sg.id
  #vpc_sec_group = "sg-0fa31bd99d9c03644"

  tags = merge (
    module.configuration.tags,
    {
      Name = "woznet_ec2"
    }
  )
}

#// 
#module "woznet_bastion" {
#  source = "../modules/ec2_instance"
#
#  ami_id = data.aws_ami.amznix2.id
#  key_name  = "Toulon"
#  subnet_id = module.woznet.public_subnet_ids[0]
#  user_data = data.template_file.user_data.rendered
#  public_ip = true
#
#  vpc_sec_group = module.woznet_sg.id
#
#  tags = merge (
#    module.configuration.tags,
#    {
#      Name = "woznet_ec2_jump"
#    }
#  )
#}

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
