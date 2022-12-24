variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "asn" {
  default = 64512
}

variable "custom_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(map(any))
  default = []
}