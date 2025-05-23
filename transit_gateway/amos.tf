resource "aws_instance" "amos" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.woznet1-sg.id]
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  user_data = data.template_file.user_data.rendered

  root_block_device {
    volume_size = 30
    #volume_type = "gp3"
    encrypted   = true
    #kms_key_id  = data.aws_kms_key.customer_master_key.arn
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "amos"
  }
}

resource "aws_route53_record" "amos" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "amos.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.amos.public_ip]
}

resource "aws_route53_record" "amos_int" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "amos.internal.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.amos.private_ip]
}
