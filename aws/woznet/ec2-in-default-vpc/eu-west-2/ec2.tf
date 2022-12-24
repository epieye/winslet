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

# don't modify the default sg. close it and create a dedicated sg for this use case.
module "default_sg" {
  source = "../../../modules/security_group"

  # "vpc-e14d9888" # Default VPC in London
  # "vpc-c54af0ac" # Default VPC in Stockholm
  vpc_id = "vpc-e14d9888"

  # If I remove the ingress rules, will it create an entirely closed default sg?
  # No. Ingress is required. tags are required too.
  # Although this isn't the same as Roy's; he's got resource default_sg. Try that instead.
  # Cool. This creates a security group, doesn't amend the default security group. 
  # Roy is right, aws_default_security_group with no ingress or egress creates a closed default security group.
  # try it in woznet. Close the default security group and create a dedicated one. 
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
      Name = "default-vpc-ssh-access"
    }
  )
}

#resource "aws_default_security_group" "default" {
#  vpc_id = "vpc-cb7a34ae"
#}

# Stockholm vpc-c54af0ac 172.31.0.0/20 172.31.16.0/20 172.31.32.0/20
# London    vpc-e14d9888 172.31.0.0/26 Why is there only one default subnet in London. It is because I defined it?
# Maybe try 172.31.16.0/26 for Stockholm

// create subnet. Normally created in the module when we create VPC. But not creating a VPC.
# why do I have subnets in London?
resource "aws_subnet" "public_subnet" {
  vpc_id = "vpc-e14d9888" # Default VPC
  count = "1"
  cidr_block = "172.31.0.0/26" # Is there a different default cidr in Stockholm? Or did I delete them?
  availability_zone = "eu-west-2a"

  map_public_ip_on_launch = true

  tags = merge(
    module.configuration.tags,
    {
      Name = "subnet-public-eu-west-2a"
    }
  )
}

// 
module "default_bastion" {
  source = "../../../modules/ec2_instance"

  ami_id = data.aws_ami.amznix2.id
  key_name  = "London"
  subnet_id = aws_subnet.public_subnet[0].id
  user_data = data.template_file.user_data.rendered
  public_ip = true

  vpc_sec_group = module.default_sg.id
  #vpc_sec_group = aws_default_security_group.default.id # Is the default VPC in use at all in Roy's VPCs?

  tags = merge (
    module.configuration.tags,
    {
      Name = "London-Sanctum"
    }
  )
}

output "public_ip" {
  value = module.default_bastion.module_ec2.public_ip
}
