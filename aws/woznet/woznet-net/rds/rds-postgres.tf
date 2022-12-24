#// 
#resource "aws_db_subnet_group" "default" {
#  name       = "woznet_db"
#  subnet_ids = [data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[0],
#                data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[1]]
#  tags = {
#    Name = "Bob"
#  }
#}
#
## sg
## I'll need access from the lambda.
## and an IAM role too.
#
#resource "aws_security_group" "woznet_db_sg" {
#  name = "woznet_db_sg"
#
#  description = "RDS postgres servers (terraform-managed)"
#  vpc_id = data.terraform_remote_state.woznet.outputs.woznet_settings.vpc_id
#
#  # Only postgres in
#  ingress {
#    from_port = 5432
#    to_port = 5432
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  # Allow all outbound traffic.
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_db_instance" "woznet_db" {
#  allocated_storage      = 100
#  db_subnet_group_name   = aws_db_subnet_group.default.id
#  engine                 = "postgres"
#  engine_version         = "11.5"
#  identifier             = "woznet-db"
#  instance_class         = "db.t2.micro"
#  username               = var.rds_username
#  password               = var.rds_password
#  skip_final_snapshot    = true
#  storage_encrypted      = false
#  publicly_accessible    = false
#  vpc_security_group_ids = [aws_security_group.woznet_db_sg.id]
#}
##  backup_retention_period  = 7   # in days
##  multi_az                 = false
##  name                     = "mydb1"
##  parameter_group_name     = "mydbparamgroup1" # if you have tuned it
##  port                     = 5432
##  storage_type             = "gp2"
##  vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
#
## can I create a database with terraform?
## automate backups
## create aurora read replica
#
##module "woznet_db" {
##  #source = "../../modules/rds" # module is focused on mysql.
##
##  allocated_storage    = 100
##  db_subnet_group_name = aws_db_subnet_group.default.id
##  engine               = "postgres"
##  engine_version       = "11.5"
##  identifier           = "woznet_db"
##  instance_class       = "db.t2.micro"
##  username             = "postgres"
##  password             = "password"
##  skip_final_snapshot  = true
##  storage_encrypted    = false
##}
#
##resource "null_resource" "db_setup" {
##
##  # runs after database and security group providing external access is created
##  depends_on = ["aws_db_instance.your_database_instance", "aws_security_group.sg_allowing_external_access"]
##
##    provisioner "local-exec" {
##        command = "database connection command goes here"
##        environment {
##          # for instance, postgres would need the password here:
##          PGPASSWORD = "${var.database_admin_password}"
##        }
##    }
##}
#
##resource "null_resource" "db_setup" {
##  provisioner "local-exec" {
##    command = "psql -h host_name_here -p 5432 -U \"${var.rds_username}\" -d \"woznet_db\" -f \"woznet_db.sql\""
##    environment = {
##      PGPASSWORD = "${var.rds_password}"
##    }
##  }
##}
#
##output "bobulike" {
##  value = aws_db_subnet_group.default
##}
#
#output "aws_db_instance" {
#  value = aws_db_instance.woznet_db.endpoint
#}
#
## psql -h {{ aws_db_instance.woznet_db.endpoint }} -p 5432 -d postgres -U postgres -W
#
