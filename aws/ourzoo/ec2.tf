/*
  Create and EC2 so I can access the EKS cluster. If it even works like that.
*/

// Find the lastest amazon2 linux 
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

module "ourzoo_sg" {
  source = "../modules/security_group"

  vpc_id = module.ourzoo.vpc_id

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
      Name = "ourzoo-sg"
    }
  )
}

// Put ourzoo is zone-b for no good reason.
module "ourzoo_ec2" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = module.ourzoo.public_subnet_ids[1]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.ourzoo_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "ourzoo_ec2"
    }
  )
}


# Output the private IP addresses. We might need them. What is the attribute?

output "private_ip" {
  value = module.ourzoo_ec2
}

output "public_ip" {
  value = module.ourzoo_ec2
}

