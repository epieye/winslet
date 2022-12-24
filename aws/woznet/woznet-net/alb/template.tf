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
  template = file("../user_data.sh")
}

resource "aws_launch_template" "ourzoo-asg-template" {
  name_prefix   = "vanuatu-"
  image_id      = data.aws_ami.amznix2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = "${base64encode(data.template_file.user_data.rendered)}"


  #subnet_id = module.woznet.public_subnet_ids[0]
  #public_ip = true


  #tags = merge (
  #  module.configuration.tags,
  #  {      
  #    Name = "woznet_ec2"
  #  }
  #)

}
# Scaling policy? CPU network utilization/

