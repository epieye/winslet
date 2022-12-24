variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  default     = "1.17"
}

variable "public_api_whitelist" {
  type        = list(string)
  description = "Public IPs to allow API access from"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to place the environment's resources in"
}

variable "node_groups" {
  description = "List of node groups"
  type = list(any)
}

variable "spot_node_groups" {
  description = "List of spot instance node groups"
  type = list(any)
}

variable "s3_access_buckets" {
  description = "List of S3 buckets that nodes are allowed to access"
  type = list(any)
}
