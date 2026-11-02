resource "aws_instance" "esteban" {
  ami           = "ami-077e4fe657a374a2d" # data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Associating a profile is useful for somethings.

  key_name = "Toulon"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.woznet-private-sg.id]
  subnet_id = aws_subnet.woznet_subnet_private_1b.id

  user_data     = <<-EOF
    #!/bin/bash
    #aws s3 cp s3://ourzoo.us/user_data.sh - | sh

    export PATH=$PATH:/usr/local/bin:/usr/bin
    export AWS_METADATA_SERVICE_TIMEOUT=10
    export AWS_METADATA_SERVICE_NUM_ATTEMPTS=5

    # Retry loop to wait for the private subnet routing table to link up to S3
    for i in {1..5}; do
      # Fetch the script safely to a temp file first, specifying the regional endpoint
      /usr/bin/aws s3 cp s3://ourzoo.us/user_data.sh /tmp/user_data.sh --region us-east-1
      if [ $? -eq 0 ]; then
        chmod +x /tmp/user_data.sh
        /bin/bash /tmp/user_data.sh
        break
      fi
      echo "S3 connection not ready, retrying in 5 seconds..."
      sleep 5
    done

  EOF

  root_block_device {
    volume_size = 30
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  # Forces Terraform to wait until routing and NAT gateways are fully ready
  depends_on = [
    aws_nat_gateway.woznet-ngw-b,
    aws_route_table_association.woznet_subnet_private_1b
  ]

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

#resource "aws_route53_record" "esteban_v6" {
# zone_id = "Z07643963KV3I332WTGCB"
#  name    = "esteban.kinaida.net"
#  type    = "AAAA"
#  ttl     = "60"
#  records = [aws_instance.esteban.ipv6_addresses[0]]
#}

