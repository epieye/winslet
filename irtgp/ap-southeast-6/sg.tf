resource "aws_security_group" "woznet-public-sg" {
  description = "Public Security Services"
  vpc_id = aws_vpc.woznet_vpc1.id

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
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32"]
  }

  tags = {
    Name = "woznet-${local.location}-public-sg"
  }
}

resource "aws_security_group" "woznet-private-sg" {
  description = "Security Services"
  vpc_id = aws_vpc.woznet_vpc1.id

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
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }

  tags = {
    Name = "woznet-${local.location}-private-sg"
  }
}

resource "aws_security_group" "woznet2-private-sg" {
  description = "Security Services"
  vpc_id = aws_vpc.woznet_vpc2.id

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
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }

  tags = {
    Name = "woznet2-${local.location}-private-sg"
  }
}

