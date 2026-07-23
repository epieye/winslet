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

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "chrisjen" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  user_data = data.template_file.user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "chrisjen"
  }
}

resource "aws_route53_record" "chrisjen" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "chrisjen.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.chrisjen.private_ip]
}

resource "aws_instance" "naomi" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet2-sg.id]
  subnet_id = aws_subnet.woznet2_subnet_private_1b.id
  user_data = data.template_file.user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "naomi"
  }
}

resource "aws_route53_record" "naomi" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "naomi.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.naomi.private_ip]
}

