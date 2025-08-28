resource "aws_instance" "esteban" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associating a profile is useful for somethings.

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-private-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  ipv6_address_count = 1
  #user_data = data.template_file.user_data.rendered
  #user_data = data.aws_s3_object.remote_user_data.body
  user_data     = <<-EOF
    #!/bin/bash
    aws s3 cp s3://ourzoo.us/user_data.sh - | sh
  EOF

  root_block_device {
    volume_size = 30
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "esteban"
  }
}	

# I can make a private zone if this is useful
resource "aws_route53_record" "esteban" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "esteban.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.esteban.private_ip]
}

resource "aws_route53_record" "esteban_v6" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "esteban.kinaida.net"
  type    = "AAAA"
  ttl     = "60"
  records = [aws_instance.esteban.ipv6_addresses[0]]
}

