/*
  Create an EC2 in the Woznet VPC.
*/

data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*.*-x86_64-ebs"] # upgrade to Amazon Linux 2023 before 2025-06-30.
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

#data "aws_ami" "amznix2" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    #values = ["amzn2-ami-hvm-2.*.*-x86_64-ebs"] # upgrade to Amazon Linux 2023 before 2025-06-30.
#    values = ["al2023-ami-*-x86_64"]      # al2023-ami-kernel-6.1-x86_64 - Why is it only matching minimal?
#  }
#
#  #filter {
#  #  name   = "virtualization-type"
#  #  values = ["hvm"]
#  #}
#
#  owners = ["137112412989"] # Amazon
#}
