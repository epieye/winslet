/*
  Create and EC2 in the default VPC so I have alinux box when I need one. 
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

module "default_sg" {
  source = "../modules/security_group"

  vpc_id = "vpc-cb7a34ae" # Default VPC

  ingress = [
    {
      from_port  = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = merge(
    module.configuration.tags,
    {
      Name = "default-vpc-ssh-access"
    }
  )
}

// create subnet. Normally created in the module when we create VPC. But not creating a VPC.
resource "aws_subnet" "public_subnet" {
  vpc_id = "vpc-cb7a34ae" # Default VPC
  count = "1"
  cidr_block = "172.31.0.0/26"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = merge(
    module.configuration.tags,
    {
      Name = "subnet-public-us-east-1a"
    }
  )
}

// 
module "default_bastion" {
  source = "../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = aws_subnet.public_subnet[0].id
  #user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.default_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "amos"
    }
  )
}

output "public_ip" {
  value = module.default_bastion
}
