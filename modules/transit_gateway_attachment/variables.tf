variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "subnet_ids" {

}
variable "vpc_id" {

}
variable "transit_gateway_id" {

}

variable "default_association" {
  default = true
}
variable "default_propagation" {
  default = true
}

variable "custom_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(object({
    destination_cidr_block         = list(string)
    transit_gateway_attachment_id  = string
  }))
  default = []
}