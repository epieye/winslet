resource "aws_instance" "esteban" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associating a profile is useful for somethings.

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet2-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_2a.id
  user_data = data.template_file.user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "esteban"
  }
}	

resource "aws_route53_record" "esteban_int" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "esteban.internal.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.esteban.private_ip]
}

