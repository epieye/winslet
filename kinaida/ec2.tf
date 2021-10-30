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

module "kinaida_sg" {
  source = "../modules/security_group"

  vpc_id = module.kinaida.vpc_id

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
      Name = "kinaida-sg"
    }
  )
}

// 
module "kinaida_ec2" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Cannes"
  subnet_id = module.kinaida.public_subnet_ids[0]
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

## Output the private IP addresses. We might need them. What is the attribute?
#output "privatec_ip" {
#  value = module.kinaida_ec2
#}
#
#output "public_ip" {
#  value = module.kinaida_ec2
#}
