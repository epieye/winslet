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
module "woznet_bastion" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
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

