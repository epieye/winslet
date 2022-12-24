variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "custom_private_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(map(any))
  default     = []
}

variable "custom_public_routes" {
  description = "Custom routes to add to the VPC"
  type        = list(map(any))
  default     = []
}

variable "base_cidr_block" {
  description = "CIDR block for VPC"
}

variable "custom_az_ids" {
  description = "allow for passing in of AZs to subnets in vpc -- for cases where they need to be declared as override (ie WorkSpaces AD only offered in x)"
  type        = list(any)
  default     = ["*"]
}

variable "nat_gateway" {
  description = "Boolean for NAT Gateway creation"
  default     = false
}

variable "internet_gateway" {
  description = "Boolean for Internet Gateway creation"
  default     = false
}
variable "endpoints" {
  description = "Custom VPC Endpoints to add to the VPC"
  type        = list(any)
  default     = []
}

variable "private_subnet_count" {
  description = "The number of private subnets to deploy in the VPC"
  type        = number
  default     = 2
}

variable "advanced_subnetting" {
  description = "Use the advanced functionality to correctly determine the subnet width."
  default     = false
}

variable "resource_tags" {
  description = "Dictionary for per resource tags."
  type        = map(map(string))
  default     = {}
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "vpc_flow_log_tags" {
  description = "Additional tags for the VPC Flow Logs"
  type        = map(string)
  default     = {}
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "vpc_flow_log_permissions_boundary" {
  description = "The ARN of the Permissions Boundary for the VPC Flow Log IAM Role"
  type        = string
  default     = null
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "create_flow_log_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for VPC Flow Logs"
  type        = bool
  default     = false
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "create_flow_log_cloudwatch_iam_role" {
  description = "Whether to create IAM role for VPC Flow Logs"
  type        = bool
  default     = false
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3 or cloud-watch-logs."
  type        = string
  default     = "cloud-watch-logs"
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = null
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided."
  type        = string
  default     = ""
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided."
  type        = string
  default     = ""
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_file_format" {
  description = "(Optional) The format for the flow log. Valid values: `plain-text`, `parquet`."
  type        = string
  default     = "plain-text"
  validation {
    condition = can(regex("^(plain-text|parquet)$",
    var.flow_log_file_format))
    error_message = "ERROR valid values: plain-text, parquet."
  }
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_hive_compatible_partitions" {
  description = "(Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3."
  type        = bool
  default     = false
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs."
  type        = string
  default     = "/aws/vpc-flow-log/"
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
  type        = number
  default     = null
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs."
  type        = string
  default     = null
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds."
  type        = number
  default     = 600
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "flow_log_per_hour_partition" {
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries."
  type        = bool
  default     = false
}

# From https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/variables.tf
variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}
