#// 
#resource "aws_db_subnet_group" "chatops_subnet_group" {
#  name       = "chatops_subnet_group"
#  subnet_ids = [
#    module.chatops.public_subnet_ids[0],
#    module.chatops.public_subnet_ids[1]
#  ]
#  tags = {
#    Name = "chatops-db"
#  }
#}
#
#resource "aws_security_group" "chatops_db_sg" {
#  name = "chatops_db_sg"
#
#  description = "RDS mysql servers (terraform-managed)"
#  vpc_id = module.chatops.vpc_id
#
#  ingress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_db_instance" "chatops_db" {
#  allocated_storage      = 100
#  db_subnet_group_name   = aws_db_subnet_group.chatops_subnet_group.id
#  engine                 = "mysql"
#  engine_version         = "8.0"
#  name                   = "events"
#  identifier             = "chatops-db"
#  instance_class         = "db.t2.micro"
#  username               = "user"
#  password               = "password"
#  skip_final_snapshot    = true
#  storage_encrypted      = false
#  publicly_accessible    = false
#  vpc_security_group_ids = [aws_security_group.chatops_db_sg.id]
#}
#
## $ echo  mysql -h `terraform output -raw aws_db_instance` events -u user -p          # substitute : for (space) --port (space)
## mysql -h chatops-db.cdi80wpde4wf.us-east-1.rds.amazonaws.com --port 3306 events -u user -p 
#output "aws_db_instance" {
#  value = aws_db_instance.chatops_db.endpoint
#}
#
##output "chatops_db_sg" {
##  value = aws_security_group.chatops_db_sg
##}
#
