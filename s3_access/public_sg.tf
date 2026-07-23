resource "aws_security_group" "woznet-public-sg" {
  name = "Lucy"
  description = "Bobs Internet Service"
  vpc_id = aws_vpc.woznet_kinaida_vpc.id

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
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32","192.168.0.0/16"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32","192.168.0.0/16"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32","192.168.0.0/16"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32","192.168.0.0/16"]
  }

  tags = {
    Name = "woznet-public-sg"
  }

  provider = aws.kinaida
}

