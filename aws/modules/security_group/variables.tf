variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "vpc_id" {

}

variable "ingress" {
  type        = list(any)
}
