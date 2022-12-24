/* db */
variable "db_allocated_storage" {
  description = "The amount of disk space on the rds node"
  default     = 100
}

variable "db_instance_class" {
  description = "The instance type of the rds node"
}

variable "db_backup_window" {
  description = "The time range backups are taken on the db. For constraints and format see PreferredBackupWindow section on https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html"
}

variable "tags" {
  description = "Map of tags to attach to AWS resource. hashology_client and hashology_environment required"
  type        = map(any)
}

variable "vpc_id" {}

variable "eks_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to allow internal access from"
}
variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to place the environment's resources in. Set this to the base module's output variable `subnet_ids`"
}

variable "db_parameter_group" {
  description = "The parameter group name to use. One will be created if not specified."
  default     = ""
}

variable "mysql_version" {
  description = "Version of MySQL"
}

variable "storage_type" {
  description = "Storage type"
  default     = "gp2"
}

variable "public_access" {
  description = "Boolean denoting public access"
  default     = false
}

variable "multi_az" {
  description = "Boolean denoting multi_az"
  default     = false
}

variable "port" {
  description = "database port"
  default     = 5432
}
