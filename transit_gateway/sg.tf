# disable default sg <- this !
# You can't delete a default security group. I thought we did.
# But no rules and nothing associated with it.
# It would be useful to see which resoruces are associated with it. Perhaps ENI.

# 3389 *might* be needed for s2s VPN. Probably not. 
# what else is needed for s2s VPN?

resource "aws_security_group" "woznet1-sg" {
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woznet1-sg"
  }
}

resource "aws_security_group" "woznet2-sg" {
  vpc_id = aws_vpc.woznet_vpc2.id
    
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woznet2-sg"
  }
}

resource "aws_security_group" "woznet3-sg" {
  vpc_id = aws_vpc.woznet_vpc3.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woznet3-sg"
  }
}

resource "aws_security_group" "woznet4-sg" {
  vpc_id = aws_vpc.woznet_vpc4.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woznet4-sg"
  }
}


resource "aws_security_group" "wozlab-alb-sg" {
  vpc_id = aws_vpc.woznet_vpc1.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["172.125.57.137/32"]
  }
  ingress {
    from_port   = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["172.125.57.137/32"]
  }

  tags = { Name = "WozLab ALB SG" }
}




# Resolver Security Group
#module "inbound_resolver_sec_group" {
#  source = "git::ssh://git@gitlab.com/onedatascan/cloudops/tf-modules.git//security_group"
#  vpc_id = module.domain_services_vpc.vpc_id
#
#  ingress = [
#    {
#      from_port   = 53
#      to_port     = 53
#      protocol    = "udp"
#      cidr_blocks = ["10.0.0.0/8"]
#    },
# ]
#
#  tags = { Name = "inbound-resolver-sg" }
#}
#

resource "aws_security_group" "inbound_resolver_sec_group" {
  vpc_id = aws_vpc.woznet_vpc1.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 53
    to_port   = 53
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Inbound Resolver Sec Group" }
}

