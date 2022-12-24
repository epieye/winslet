# I need an EC2 to be a target for the Lambda agent

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

module "hole_in_the_wall_bastion" {
  source = "../../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "Toulon"
  subnet_id = module.hole_in_the_wall.public_subnet_ids[0]
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.hole_in_the_wall_sg.id

  tags = merge (
    module.configuration.tags,
    {
      Name = "hole-in-the-wall-ec2"
    }
  )
}

output "hole_in_the_wall_bastion_public_ip" {
  value = module.hole_in_the_wall_bastion.module_ec2.public_ip
}

