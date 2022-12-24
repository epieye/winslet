#/*
#  Create an EC2 in the default VPC so I have a linux box when I need one. 
#*/
#
#
## igw-d97ef7bc was detached from the VPC.
#
#
#
#// Thanks Steve.
#data "aws_ami" "amznix2" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-2.*.*-x86_64-ebs"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["137112412989"] # Amazon
#}
#
#data "template_file" "user_data" {
#  template = file("user_data.sh")
#}
#
#// create subnet. Normally created in the module when we create VPC. But not creating a VPC.
#resource "aws_subnet" "public_subnet" {
#  vpc_id = "vpc-cb7a34ae" # Default VPC
#  count = "1"
#  cidr_block = "172.31.0.0/26"
#  availability_zone = "us-east-1a"
#
#  map_public_ip_on_launch = true
#
#  tags = merge(
#    module.configuration.tags,
#    {
#      Name = "subnet-public-us-east-1a"
#    }
#  )
#}
#
#// 
#module "default_bastion" {
#  source = "../../../modules/ec2_instance"
#
#  ami_id = data.aws_ami.amznix2.id
#  key_name  = "Toulon"
#  subnet_id = aws_subnet.public_subnet[0].id
#  user_data = data.template_file.user_data.rendered
#  public_ip = true
#
#  vpc_sec_group = module.default_sg.id
#  #vpc_sec_group = aws_default_security_group.default.id # Is the default VPC in use at all in Roy's VPCs?
#
#  tags = merge (
#    module.configuration.tags,
#    {
#      Name = "amos"
#    }
#  )
#}
#
### second EC2 for testing mirroring.
##
##module "secondary_server" {
##  source = "../../../modules/ec2_instance"
##
##  ami_id = data.aws_ami.amznix2.id
##  key_name  = "Toulon"
##  subnet_id = aws_subnet.public_subnet[0].id
##  user_data = data.template_file.user_data.rendered
##  public_ip = true # Just so we can use user_data.
##
##  vpc_sec_group = module.default_sg.id
##  #vpc_sec_group = aws_default_security_group.default.id # Is the default VPC in use at all in Roy's VPCs?
##
##  tags = merge (
##    module.configuration.tags,
##    {
##      Name = "natalie"
##    }
##  )
##}
#
#
#
#output "public_ip_of_bastion_server" {
#  value = module.default_bastion.module_ec2.public_ip
#}
#
##output "public_ip_of_secondary_server" {
##  value = module.secondary_server.module_ec2.public_ip
##}
#
