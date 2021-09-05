variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "secrets" {
  description = "Map of secrets to store"
  type        = map(string)
}

variable "base_secret_name" {
  description = "Base secret to combine with"
  default = ""
}

