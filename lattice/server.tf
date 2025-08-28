#
#
# See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_vpc_association
#
#

resource "aws_instance" "app1" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-private-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
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
    Name = "app-server1"
  }
}

resource "aws_route53_record" "app1" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "app1.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.app1.private_ip]
}

resource "aws_instance" "app2" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-private-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
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
    Name = "app-server2"
  }
}

resource "aws_route53_record" "app2" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "app2.kinaida.net"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.app1.private_ip]
}

