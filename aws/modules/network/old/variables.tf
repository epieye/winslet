variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "custom_private_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(map(any))
  default = []
}

variable "custom_public_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(map(any))
  default = []
}

variable "base_cidr_block" {
  description = "CIDR block for VPC"
}

variable "custom_az_ids" {
   description = "allow for passing in of AZs to subnets in vpc -- for cases where they need to be declared as override (ie WorkSpaces AD only offered in x)"
   type        = list(any)
   default= ["*"]
}

variable "nat_gateway" {
  description = "Boolean for NAT Gateway creation"
  default = false
}

variable "internet_gateway" {
  description = "Boolean for Internet Gateway creation"
  default = false
}
variable "endpoints" {
  description = "Custom VPC Endpoints to add to the VPC"
  type        = list(any)
  default = []
}
