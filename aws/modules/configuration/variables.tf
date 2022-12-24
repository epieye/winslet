variable "tags" {
  description = "Map of tags to attach to AWS resource. hashology_client and hashology_environment required"
  type        = map(string)
}
