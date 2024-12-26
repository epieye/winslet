# disable default sg <- this !
# You can't delete a default security group. I thought we did.
# But no rules and nothing associated with it.
# It would be useful to see which resoruces are associated with it. Perhaps ENI.

resource "aws_security_group" "woznet1-sg" {
  description = "Bobs Internet Service"
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
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "woznet1-sg"
  }
}
