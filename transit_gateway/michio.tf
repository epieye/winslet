resource "aws_instance" "michio" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associating a profile is useful for somethings.

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet2-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_2b.id
  user_data = data.template_file.user_data.rendered

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "michio"
  }
}	

#resource "aws_route53_record" "arjun" {
#  zone_id = "Z07643963KV3I332WTGCB"
#  name    = "arjun.kinaida.net"
#  type    = "A"
#  ttl     = "60"
#  records = [aws_instance.arjun.public_ip]
#}

resource "aws_route53_record" "michio_int" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "michio.internal.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.michio.private_ip]
}

