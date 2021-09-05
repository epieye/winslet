resource "aws_db_subnet_group" "group" {
  name       = var.tags["Name"]
  subnet_ids = var.db_subnet_ids
}

resource "aws_security_group" "db_sg" {
  name        = "${var.tags["Name"]}-sg"
  description = "${var.tags["Name"]}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["50.18.249.58/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "random_string" "db_root_password" {
  length  = 32
  special = false
}

resource "aws_db_parameter_group" "pg" {
  count  = var.db_parameter_group != "" ? 0 : 1
  name   = "${var.tags["Name"]}-pg"
  family = "mysql5.6"

  parameter {
    name  = "binlog_format"
    value = "ROW"
  }

  parameter {
    name  = "binlog_cache_size"
    value = "32768"
  }

  parameter {
    name = "sync_binlog"
    value = "1"
  }

}

resource "aws_db_instance" "instance" {
  identifier              = var.tags["Name"]
  allocated_storage       = var.db_allocated_storage
  storage_type            = var.storage_type
  engine                  = "mysql"
  engine_version          = var.mysql_version
  instance_class          = var.db_instance_class
  username                = "hashology"
  password                = random_string.db_root_password.result
  db_subnet_group_name    = aws_db_subnet_group.group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  license_model           = "general-public-license"
  publicly_accessible     = var.public_access
  skip_final_snapshot     = true
  multi_az                = var.multi_az
  backup_window           = var.db_backup_window
  backup_retention_period = 30
  parameter_group_name    = var.db_parameter_group != "" ? var.db_parameter_group : join("", aws_db_parameter_group.pg.*.name)
  enabled_cloudwatch_logs_exports = ["error"]
  storage_encrypted       = true
  performance_insights_enabled = true
  deletion_protection = true

  tags = var.tags
}


output "db_address" {
  value = aws_db_instance.instance.address
}

output "db_password" {
  value     = aws_db_instance.instance.password
  sensitive = true
}

output "sg_id" {
  value     = aws_security_group.db_sg.id
}

output "db_identifier" {
  value = aws_db_instance.instance.identifier
}
