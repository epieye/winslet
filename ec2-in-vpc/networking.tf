# Create everything for basic setup including bastion.
# The point is I want to learn something new, not spend half the time recreating the basics.

resource "aws_vpc" "woznet_vpc" {
  cidr_block = "192.168.12.0/24"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  assign_generated_ipv6_cidr_block = true
    
  tags = {
    Name = "woznet-vpc"
  }
}

resource "aws_internet_gateway" "woznet-igw" {
  vpc_id = aws_vpc.woznet_vpc.id
  tags = {
    Name = "woznet-igw"
  }
}

resource "aws_subnet" "woznet_subnet_public_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.0/27"
  ipv6_cidr_block      = cidrsubnet(aws_vpc.woznet_vpc.ipv6_cidr_block, 8, 0)
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = "true"

  tags = {
    Name = "woznet-subnet-public-1a"
  }
}

resource "aws_subnet" "woznet_subnet_public_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.32/27"
  ipv6_cidr_block      = cidrsubnet(aws_vpc.woznet_vpc.ipv6_cidr_block, 8, 1)
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = "true" 

  tags = {
    Name = "woznet1-subnet-public-1b"
  }
}

resource "aws_subnet" "woznet_subnet_private_1a" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.128/27"
  ipv6_cidr_block      = cidrsubnet(aws_vpc.woznet_vpc.ipv6_cidr_block, 8, 2)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet1-subnet-private-1a"
  }
}

resource "aws_subnet" "woznet_subnet_private_1b" {
  vpc_id = aws_vpc.woznet_vpc.id
  cidr_block = "192.168.12.160/27"
  ipv6_cidr_block      = cidrsubnet(aws_vpc.woznet_vpc.ipv6_cidr_block, 8, 3)
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "woznet-subnet-private-1b"
  }
}

resource "aws_eip" "woznet-eip-a" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-a"
  }
}

resource "aws_eip" "woznet-eip-b" {
  public_ipv4_pool = "amazon"

  tags = {
    "Name": "woznet-eip-b"
  }
}

resource "aws_nat_gateway" "woznet-ngw-a" {
  allocation_id = aws_eip.woznet-eip-a.id
  subnet_id = aws_subnet.woznet_subnet_public_1a.id

  tags = {
    Name = "woznet-ngw-a"
  }

  depends_on = [aws_internet_gateway.woznet-igw]
}

resource "aws_nat_gateway" "woznet-ngw-b" {
  allocation_id = aws_eip.woznet-eip-b.id
  subnet_id = aws_subnet.woznet_subnet_public_1b.id

  tags = {
    Name = "woznet-ngw-b"
  }

  depends_on = [aws_internet_gateway.woznet-igw]
}

# Do I need an egress only internet gateway for the IPV6 in private subnets?
#resource "aws_egress_only_internet_gateway" "sample_ipv6_egress_igw" {
#  vpc_id = aws_vpc.sample_vpc.id
#
#  tags = {
#    "Name" = "Sample-VPC-IPv6-Egress-Only-IGW"
#  }
#}

resource "aws_security_group" "woznet-public-sg" {
  name = "Lucy"
  description = "Bobs Internet Service"
  vpc_id = aws_vpc.woznet_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] 
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["50.168.198.58/32", "172.125.57.137/32"]
    ipv6_cidr_blocks = ["2600:1700:3b20:6ff0:e2cb:4eff:fefc:14bb/128"] 
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["50.168.198.58/32", "172.125.57.137/32"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["50.168.198.58/32", "172.125.57.137/32"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["50.168.198.58/32", "172.125.57.137/32"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
  }

  tags = {
    Name = "woznet-public-sg"
  }
}

#resource "aws_security_group" "woznet-public-sg" {
#  name        = "woznet-public-sg"
#  description = "Bobs Internet Service"
#  vpc_id      = aws_vpc.woznet_vpc.id
#
#  tags = {
#    Name = "woznet-public-sg"
#  }
#}
#
#resource "aws_vpc_security_group_ingress_rule" "woznet-public-sg-rule1" {
#  security_group_id = aws_security_group.woznet-public-sg.id
#  cidr_ipv4   = ["50.168.198.58/32", "172.125.57.137/32"]
#  from_port   = 22
#  ip_protocol = "tcp"
#  to_port     = 22
#}
#
#resource "aws_vpc_security_group_ingress_rule" "woznet-public-sg-rule2" {
#  security_group_id = aws_security_group.woznet-public-sg.id
#  cidr_ipv4   = "172.125.57.137/32"
#  from_port   = 80
#  ip_protocol = "tcp"
#  to_port     = 80
#}

resource "aws_security_group" "woznet-private-sg" {
  description = "Bobs Internet Service"
  vpc_id = aws_vpc.woznet_vpc.id

  # How do I stop it from being called terraform-20230906203909438500000004 ?

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  tags = {
    Name = "woznet-private-sg"
  }
}

resource "aws_route_table" "woznet-rtb" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.woznet-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.woznet-igw.id
  }

  tags = {
    Name = "woznet-publicrtb"
  }
} 

resource "aws_route_table_association" "woznet_subnet_public_1a" {
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  route_table_id = aws_route_table.woznet-rtb.id
}

resource "aws_route_table_association" "woznet_subnet_public_1b" {
  subnet_id = aws_subnet.woznet_subnet_public_1b.id
  route_table_id = aws_route_table.woznet-rtb.id
}

resource "aws_route_table" "woznet1a-private-rtb" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.woznet-ngw-a.id
  }

  tags = {
    Name = "woznet1a-private-rtb"
  }
} 

resource "aws_route_table_association" "woznet_subnet_private_1a" {
  subnet_id = aws_subnet.woznet_subnet_private_1a.id
  route_table_id = aws_route_table.woznet1a-private-rtb.id
}

resource "aws_route_table" "woznet1b-private-crt" {
  vpc_id = aws_vpc.woznet_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.woznet-ngw-b.id
  }

  tags = {
    Name = "woznet1b-private-crt"
  }
} 

resource "aws_route_table_association" "woznet_subnet_private_1b" {
  subnet_id = aws_subnet.woznet_subnet_private_1b.id
  route_table_id = aws_route_table.woznet1b-private-crt.id
}

#data "template_file" "user_data" {
#  template = file("user_data.sh")
#}

#data "aws_s3_bucket_object" "remote_user_data" {
#  bucket = "ourzoo.us"
#  key    = "user_data.sh"
#}

data "aws_s3_object" "remote_user_data" {
  bucket = "ourzoo.us"
  key    = "user_data.sh"
}

data "aws_ami" "amznix2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]      # al2023-ami-kernel-6.1-x86_64 - Why is it only matching minimal?
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "amos" {
  ami           = data.aws_ami.amznix2.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name = "Toulon"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.woznet-public-sg.id]
  subnet_id = aws_subnet.woznet_subnet_public_1a.id
  ipv6_address_count = 1
  #user_data = data.template_file.user_data.rendered
  #user_data = data.aws_s3_object.remote_user_data.body
  user_data     = <<-EOF
    #!/bin/bash
    aws s3 cp s3://ourzoo.us/user_data.sh - | sh
  EOF

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

resource "aws_route53_record" "amos_v6" {
 zone_id = "Z07643963KV3I332WTGCB"
  name    = "amos.kinaida.net"
  type    = "AAAA"
  ttl     = "60"
  records = [aws_instance.amos.ipv6_addresses[0]]
}


