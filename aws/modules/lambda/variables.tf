variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
}

variable "schedule_expression" {
  description = "The schedule/frequency in running the lamba function"
  type        = string
  default     = ""
}

variable "lambda_source_dir" {
  description = "The directory where the lambda function code is stored"
  type        = string
  default     = ""
}

variable "iam_role_arn" {
  description = "ARN for IAM Role to run Lambda function"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.8"
}

variable "handler" {
  description = "Handler function"
  type        = string
  default     = "main.handler"
}

variable "description" {
  description = "Description for the lambda function"
  type        = string
  default     = ""
}
