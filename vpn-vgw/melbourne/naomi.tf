/*
  Create an EC2 in the Woznet VPC.
*/

data "template_file" "user_data" {
  template = file("user_data.sh")
}

data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]      # al2023-ami-kernel-6.1-x86_64 - Why is it only matching minimal?
  }

  #owners = ["137112412989"] # Amazon. I think this number is different in another region.
}

resource "aws_instance" "naomi" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t3.small"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associating a profile is useful for somethings.

  key_name = "Torremolinos"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.woznet-melbourne-public-sg.id]
  subnet_id = aws_subnet.woznet_subnet_public_1a.id

  user_data = data.template_file.user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "naomi"
  }
}

