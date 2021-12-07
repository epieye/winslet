// 
resource "aws_db_subnet_group" "default" {
  name       = "woznet_db"
  subnet_ids = [data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[0],
                data.terraform_remote_state.woznet.outputs.woznet_settings.private_subnet_ids[1]]
  tags = {
    Name = "Bob"
  }
}

resource "aws_db_instance" "woznet_db" {
  allocated_storage    = 100
  db_subnet_group_name = aws_db_subnet_group.default.id
  engine               = "postgres"
  engine_version       = "11.5"
  identifier           = "woznet-db"
  instance_class       = "db.t2.micro"
  username             = "postgres"
  password             = "password"
  skip_final_snapshot  = true
  storage_encrypted    = false
}

# can I create a database with terraform?
# automate backups
# create aurora read replica

#module "woznet_db" {
#  #source = "../../modules/rds" # module is focused on mysql.
#
#  allocated_storage    = 100
#  db_subnet_group_name = aws_db_subnet_group.default.id
#  engine               = "postgres"
#  engine_version       = "11.5"
#  identifier           = "woznet_db"
#  instance_class       = "db.t2.micro"
#  username             = "postgres"
#  password             = "password"
#  skip_final_snapshot  = true
#  storage_encrypted    = false
#}

#output "bobulike" {
#  value = aws_db_subnet_group.default
#}

output "aws_db_instance" {
  value = aws_db_instance.woznet_db.endpoint
}
