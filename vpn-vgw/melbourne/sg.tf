# disable default sg <- this !
# You can't delete a default security group. I thought we did.
# But no rules and nothing associated with it.
# It would be useful to see which resources are associated with it. Perhaps ENI.
# Alex did this I think.

resource "aws_security_group" "woznet-melbourne-public-sg" {
  description = "Public Security Services"
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
    cidr_blocks = ["32.141.185.206/32", "172.125.57.137/32"]
  }

  tags = {
    Name = "woznet-public-sg"
  }
}


resource "aws_security_group" "woznet-sg" {
  description = "Security Services"
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
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }
  ingress {
    from_port = 500
    to_port = 500
    protocol = "udp"
    cidr_blocks = ["3.223.186.171/32", "54.208.142.174/32"]
  }
  ingress {
    from_port = 4500
    to_port = 4500
    protocol = "udp"
    cidr_blocks = ["3.223.186.171/32", "54.208.142.174/32"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8"]
  }

  tags = {
    Name = "woznet-sg"
  }
}
