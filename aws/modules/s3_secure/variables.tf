variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "tags" {
  description = "Map of tags to attach to AWS resource."
  type        = map(string)
  default     = {}
}

// =======================================
// ============ ACL Settings =============
// =======================================

variable "acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write."
  type        = string
  default     = "private"
  validation {
    condition     = can(regex("^private|public-read|public-read-write|aws-exec-read|authenticated-read|log-delivery-write$", var.acl))
    error_message = "Variable acl must be one of private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write."
  }
}

variable "block_public_acls" {
  description = "Block public access to buckets and objects granted through new access control lists (ACLs)"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public access to buckets and objects granted through any access control lists (ACLs)"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Block public access to buckets and objects granted through new public bucket policies"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Block public and cross-account access to buckets and objects through any public bucket policies"
  type        = bool
  default     = true
}

// =======================================
// ============ ACL Settings =============
// =======================================

// =======================================
// ========= Encryption Settings =========
// =======================================

variable "sse_setting" {
  description = "Server-side encryption protects data at rest.  Valid values are sse-s3, sse-kms-amk, sse-kms-cmk. Defaults to sse-s3."
  type        = string
  default     = "sse-s3"
  validation {
    condition     = can(regex("^sse-s3|sse-kms-amk|sse-kms-cmk$", var.sse_setting))
    error_message = "Variable sse_setting must be one of sse-s3, sse-kms-amk, sse-kms-cmk."
  }
}

variable "allow_multiple_kms_keys" {
  # If this is allowed the x-amz-server-side-encryption-aws-kms-key-id policy check 
  # needs to support an array of kms keys instead of a single value
  # The initial version will simply not include the kms key id check, but enforce encryption
  # with the x-amz-server-side-encryption check
  description = "If more than one KMS key will be used to encrypt objects in the bucket."
  default = "false"
}

variable "sse_s3_kms_key_arn" {
  description = "The arn of of an aws managed (amk) or customer managed (cmk) kms key used for server side encryption"
  type        = string
  default     = ""
}

// =======================================
// ========= Encryption Settings =========
// =======================================

// =======================================
// ======== Access Policy Settings =======
// =======================================

variable "apply_cur_report_bucket_policy" {
  description = "Apply AWS policy required for Cost and Usage reporting s3 bucket"
  type        = bool
  default     = false
}

// ====================================

variable "allow_get_bucket_location" {
  description = "Allow Principal to use the getBucketLocation operation"
  type        = bool
  default     = false
}

variable "grant_allow_get_bucket_location_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "get_bucket_location_condition" {
  description = "Adds a condition for the GetBucketLocation action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_list_bucket" {
  description = "Allow Principal to use the listBucket operation"
  type        = bool
  default     = false
}

variable "grant_allow_list_bucket_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "list_bucket_condition" {
  description = "Adds a condition for the GetObject action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_get_bucket_acl" {
  description = "Allow Principal to use the getBucketAcl operation"
  type        = bool
  default     = false
}

variable "grant_allow_get_bucket_acl_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "get_bucket_acl_condition" {
  description = "Adds a condition for the GetBucketAcl action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_get_bucket_policy" {
  description = "Allow Principal to use the getBucketPolicy operation"
  type        = bool
  default     = false
}

variable "grant_allow_get_bucket_policy_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "get_bucket_policy_condition" {
  description = "Adds a condition for the GetBucketPolicy action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_get_object" {
  description = "Allow Principal to use the getObject operation"
  type        = bool
  default     = false
}

variable "grant_allow_get_object_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "get_object_condition" {
  description = "Adds a condition for the GetObject action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_delete_object" {
  description = "Allow Principal to use the deleteObject operation"
  type        = bool
  default     = false
}

variable "grant_allow_delete_object_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "delete_object_condition" {
  description = "Adds a condition for the DeleteObject action."
  type        = string
  default     = "{}"
}

// ====================================

variable "allow_put_object" {
  description = "Allow Principal to upload objects to the bucket"
  type        = bool
  default     = false
}

variable "grant_allow_put_object_to_principal" {
  description = "A principal identifier.  Can be an ARN, account number, canonical user, etc.  See: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-accounts"
  type        = string
  default     = ""
}

variable "put_object_condition" {
  description = "Adds a condition for the PutObject action."
  type        = string
  default     = "{}"
}

// =======================================
// ======== Access Policy Settings =======
// =======================================

