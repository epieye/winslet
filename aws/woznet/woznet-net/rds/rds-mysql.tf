// 
resource "aws_db_subnet_group" "woznet_subnet_group" {
  name       = "woznet_subnet_group"
  subnet_ids = [data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[0],
                data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[1]]
  tags = {
    Name = "Bob"
  }
}

# Do I need a proxy? No.
# https://docs.aws.amazon.com/lambda/latest/dg/configuration-database.html

resource "aws_security_group" "woznet_db_sg" {
  name = "woznet_db_sg"

  description = "RDS mysql servers (terraform-managed)"
  vpc_id = data.terraform_remote_state.woznet.outputs.woznet_settings.vpc_id

  # Only mysql in
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "woznet_db" {
  allocated_storage      = 100
  db_subnet_group_name   = aws_db_subnet_group.woznet_subnet_group.id
  engine                 = "mysql"
  engine_version         = "8.0"
  name                   = "events"
  identifier             = "woznet-db"
  instance_class         = "db.t2.micro"
  username               = "user"
  password               = "password"
  skip_final_snapshot    = true
  storage_encrypted      = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.woznet_db_sg.id]
}

output "aws_db_instance" {
  value = aws_db_instance.woznet_db.endpoint
}

output "woznet_db_sg" {
  value = aws_security_group.woznet_db_sg
}
