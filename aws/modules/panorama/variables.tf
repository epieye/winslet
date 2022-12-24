variable "panorama_version" {
  description = "Select which Panorama version to deploy"
  default     = "9.1.2"
}

variable "panoramas" {
  type        = any
  description = "Map of Panoramas to be built"
  default     = {}
}

variable "subnets_map" {
  type        = map(any)
  description = "Map of subnet name to ID, can be passed from remote state output or data source"
  default     = {}
  # Example Format:
  # subnets_map = {
  #   "panorama-mgmt-1a" = "subnet-0e1234567890"
  #   "panorama-mgmt-1b" = "subnet-0e1234567890"
  # } 
}

variable "security_groups_map" {
  type        = any
  description = "Map of security group name to ID, can be passed from remote state output or data source"
  default     = {}
  # Example Format:
  # security_groups_map = {
  #   "panorama-mgmt-inbound-sg" = "sg-0e1234567890"
  #   "panorama-mgmt-outbound-sg" = "sg-0e1234567890"
  # } 
}
