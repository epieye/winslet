data "aws_caller_identity" "current" {}

// =====================================
// ========= Standard Policies =========
// =====================================

// These are defined as HCL because their structure is predictable

data "aws_iam_policy_document" "standard_policies" {
  statement {
    sid       = "Deny non-HTTPS access"
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:*"]
    resources = ["${local.bucket_arn}/*"]
    condition {
      test      = "Bool"
      variable  = "aws:SecureTransport"
      values    = ["false"]
    }
  }

  statement {
    sid       = "Deny incorrect sse encryption header."
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]
    condition {
      test      = "StringNotEquals"
      variable  = var.sse_setting == "sse-kms-amk" || var.sse_setting == "sse-kms-cmk" ? "s3:x-amz-server-side-encryption-aws-kms-key-id" : "s3:x-amz-server-side-encryption"
      values    = [var.sse_setting == "sse-kms-amk" || var.sse_setting == "sse-kms-cmk" ? "${var.sse_s3_kms_key_arn}" : "AES256" ]
    }
  }

  statement {
    sid       = "Deny unencrypted object uploads."
    effect    = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]
    condition {
      test      = var.sse_setting == "sse-kms-amk" || var.sse_setting == "sse-kms-cmk" ? "StringNotEquals" : "Null"
      variable  = "s3:x-amz-server-side-encryption"
      values    = [var.sse_setting == "sse-kms-amk" || var.sse_setting == "sse-kms-cmk" ? "aws:kms" : "true" ]
    }
  }

  statement {
    sid       = "Allow PowerUser to Fully Manage Bucket."
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    actions   = ["s3:*"]
    resources = ["${local.bucket_arn}"]
    condition {
      test      = "ForAnyValue:ArnLike"
      variable  = "aws:PrincipalArn"
      values    = ["arn:aws:iam::*:role/*AWSPowerUserAccess*"]
    }
  }
}

data "aws_iam_policy_document" "cur_policy" {
  statement {
    sid       = "Stmt1335892150622"
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl","s3:GetBucketPolicy"]
    resources = ["${local.bucket_arn}"]
  }

  statement {
    sid       = "Stmt1335892526596"
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]
  }
}

// =====================================
// ========= Standard Policies =========
// =====================================

// ===================================
// ========= Action Policies =========
// ===================================

// These are defined as templates because HCL can't handle arbitrarily deep condition statements
// The module user is expect to prepare the condition snippit with jsonencode()

data "template_file" "allow_get_bucket_location" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to get the bucket's region"
    effect    = "Allow"
    principal = var.grant_allow_get_bucket_location_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_get_bucket_location_to_principal
    action    = jsonencode(["s3:GetBucketLocation"])
    resource  = local.bucket_arn
    condition = var.get_bucket_location_condition
  }
}

data "aws_iam_policy_document" "allow_get_bucket_location" {
  source_json = data.template_file.allow_get_bucket_location.rendered
}

//==========================

data "template_file" "allow_list_bucket" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to use the listBucket operation"
    effect    = "Allow"
    principal = var.grant_allow_list_bucket_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_list_bucket_to_principal
    action    = jsonencode(["s3:ListBucket"])
    resource  = local.bucket_arn
    condition = var.list_bucket_condition
  }
}

data "aws_iam_policy_document" "allow_list_bucket" {
  source_json = data.template_file.allow_list_bucket.rendered
}

//==========================

data "template_file" "allow_get_bucket_acl" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to get the bucket's acl"
    effect    = "Allow"
    principal = var.grant_allow_get_bucket_acl_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_get_bucket_acl_to_principal
    action    = jsonencode(["s3:GetBucketAcl"])
    resource  = local.bucket_arn
    condition = var.get_bucket_acl_condition
  }
}

data "aws_iam_policy_document" "allow_get_bucket_acl" {
  source_json = data.template_file.allow_get_bucket_acl.rendered
}

//==========================

data "template_file" "allow_get_bucket_policy" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to get the bucket's policy"
    effect    = "Allow"
    principal = var.grant_allow_get_bucket_policy_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_get_bucket_policy_to_principal
    action    = jsonencode(["s3:GetBucketPolicy"])
    resource  = local.bucket_arn
    condition = var.get_bucket_policy_condition
  }
}

data "aws_iam_policy_document" "allow_get_bucket_policy" {
  source_json = data.template_file.allow_get_bucket_policy.rendered
} 

//==========================

data "template_file" "allow_get_object" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to use the getObject operation"
    effect    = "Allow"
    principal = var.grant_allow_get_object_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_get_object_to_principal
    action    = jsonencode(["s3:GetObject", "s3:GetObjectTagging"])
    resource  = "${local.bucket_arn}/*"
    condition = var.get_object_condition
  }
}

data "aws_iam_policy_document" "allow_get_object" {
  source_json = data.template_file.allow_get_object.rendered
}

#// HERE
#data "template_file" "allow_public_get_object" {
#  template = file("${path.module}/policies/allow_policy_template.json")
#
#  vars = {
#    sid       = "Allow Public Read Get Object for S3-based website"
#    effect    = "Allow"
#    principal = "*"
#    action    = jsonencode(["s3:GetObject"])
#    resource  = "${local.bucket_arn}/*"
#    condition = var.get_object_condition
#  }
#}
#
#data "aws_iam_policy_document" "allow_public_get_object" {
#  source_json = data.template_file.allow_public_get_object.rendered
#}


//==========================

data "template_file" "allow_put_object" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to upload objects to the bucket"
    effect    = "Allow"
    principal = var.grant_allow_put_object_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_put_object_to_principal
    action    = jsonencode(["s3:PutObject", "s3:PutObjectTagging"])
    resource  = "${local.bucket_arn}/*"
    condition = var.put_object_condition
  }
}

data "aws_iam_policy_document" "allow_put_object" {
  source_json = data.template_file.allow_put_object.rendered
}

//==========================

data "template_file" "allow_delete_object" {
  template = file("${path.module}/policies/allow_policy_template.json")

  vars = {
    sid       = "Allow Principal to use the DeleteObject operation"
    effect    = "Allow"
    principal = var.grant_allow_delete_object_to_principal == "" ? jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) : var.grant_allow_delete_object_to_principal
    action    = jsonencode(["s3:DeleteObject"])
    resource  = "${local.bucket_arn}/*"
    condition = var.delete_object_condition
  }
}

data "aws_iam_policy_document" "allow_delete_object" {
  source_json = data.template_file.allow_delete_object.rendered
}

// ===================================
// ========= Action Policies =========
// ===================================

locals {

  bucket_arn  = "arn:aws:s3:::${var.bucket_name}"

  override_policy_documents = compact([
    var.apply_cur_report_bucket_policy ? "" : data.aws_iam_policy_document.standard_policies.json,
    var.apply_cur_report_bucket_policy ? data.aws_iam_policy_document.cur_policy.json : "",

    var.allow_get_bucket_location ? data.aws_iam_policy_document.allow_get_bucket_location.json : "",
    var.allow_list_bucket ? data.aws_iam_policy_document.allow_list_bucket.json : "",
    var.allow_get_bucket_acl ? data.aws_iam_policy_document.allow_get_bucket_acl.json : "",
    var.allow_get_bucket_policy ? data.aws_iam_policy_document.allow_get_bucket_policy.json : "",
    var.allow_get_object ? data.aws_iam_policy_document.allow_get_object.json : "",
    #var.allow_public_get_object ? data.aws_iam_policy_document.allow_public_get_object.json : "",
    var.allow_delete_object ? data.aws_iam_policy_document.allow_delete_object.json : "",
    var.allow_put_object ? data.aws_iam_policy_document.allow_put_object.json : ""

  ])
}

data "aws_iam_policy_document" "aggregated_policy" {
  override_policy_documents = local.override_policy_documents
}

//==========================

resource "aws_s3_bucket" "target_bucket" {
  bucket        = var.bucket_name
  acl           = var.acl

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.sse_s3_kms_key_arn
        sse_algorithm     = var.sse_setting == "sse-s3" ? "AES256" : "aws:kms"
      }
    }
  }

  policy = data.aws_iam_policy_document.aggregated_policy.json

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )  
}

resource "aws_s3_bucket_public_access_block" "target_bucket" {
  bucket = aws_s3_bucket.target_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

#resource "aws_s3_bucket_ownership_controls" "target_bucket" {
#  bucket = aws_s3_bucket.target_bucket.id
#
#  rule {
#    object_ownership = "BucketOwnerEnforced"
#  }
#}

output "target_bucket" {
  value = aws_s3_bucket.target_bucket.id
}

