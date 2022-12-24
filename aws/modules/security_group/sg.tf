resource "aws_security_group" "sg" {

  name        = var.tags["Name"]
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "ingress" {
  count = length(var.ingress)
  type              = "ingress"
  from_port         = var.ingress[count.index].from_port
  to_port           = var.ingress[count.index].to_port
  protocol          = var.ingress[count.index].protocol
  cidr_blocks       = var.ingress[count.index].cidr_blocks
  security_group_id = aws_security_group.sg.id
}

output "id" {
  value = aws_security_group.sg.id
}

