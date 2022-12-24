variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "ami_id" {
  type = string
  default = ""
}

##Normally a numeric id passed from ec2 template, but names can also be used for ami lookup/filtering -- if none, assume amazon
##IT IS BEST TO PASS THIS FROM EC2 TEMPLATE! (required in order to properly lookup ami platform which determines persistent userdata scripting in EC2 module) - SD
variable "ami_owner_id" {
  default = "amazon"

  validation {
    condition = (
      length(var.ami_owner_id) > 4 &&
        var.ami_owner_id != "amazon"
      )
    error_message = "Please pass ami_owner_id as part of your EC2 template. This is now a required parameter so that we can lookup platform type within the EC2 module."
  }
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

variable "instance_initiated_shutdown_behavior" {
  default = "stop"
}
