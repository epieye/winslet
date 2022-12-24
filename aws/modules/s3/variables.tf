variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "policy" {
  description = "Policy to attach to bucket"
  type = any
  default = ""
}

