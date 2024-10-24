#resource "aws_instance" "chrisjen" {
#  ami           = data.aws_ami.amznix2.id
#  instance_type = "t2.micro"
#
#  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
#
#  key_name = "Toulon"
#  associate_public_ip_address = false
#  vpc_security_group_ids = [aws_security_group.woznet1-sg.id]
#  subnet_id = aws_subnet.woznet_subnet_private_1b.id
#  user_data = data.template_file.user_data.rendered
#
#  metadata_options {
#    http_endpoint = "enabled"
#    instance_metadata_tags = "enabled"
#  }
#
#  tags = {
#    Name = "chrisjen"
#  }
#}
#
#resource "aws_route53_record" "chrisjen_int" {
#  zone_id = aws_route53_zone.internal.zone_id
#  name    = "chrisjen.internal.kinaida.net"
#  type    = "A"
#  ttl     = "60"
#  records = [aws_instance.chrisjen.private_ip]
#}
#
## sadavir esteban
