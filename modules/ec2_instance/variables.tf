variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "ami_id" {
  type = string
  default = ""
}
variable "type" {
  default="t3.micro"
}

variable "subnet_id" {
  
}
variable "key_name" {
  default=""
}
variable "instance_profile" {
  default=""
}
variable "user_data" {
  default=""
}
variable "disk_size" {
  default = 10
}

variable "public_ip" {
  default = false
}

variable "vpc_sec_group" {

}

variable "dns_name" {
  default = ""
}

