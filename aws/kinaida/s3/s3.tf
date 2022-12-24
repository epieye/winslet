data "aws_caller_identity" "current" {}

# 895779482413 uat-ai  remote account -> Ourzoo  742629497219
# 239609601782 prod-ai this   account -> Kinaida 714474267469 

locals {
  #trusted_account_principals_write = jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]})
  #trusted_account_principals_read =  jsonencode({"AWS"=[data.aws_caller_identity.current.account_id]}) # ,"742629497219"

  s3_shared_write_account_principals = jsonencode(
    {"AWS"=[
      "arn:aws:iam::714474267469:root"
    ]}
  )

  # remove arn:aws:iam::742629497219:root - at least this got me Access Denied - so the conditions aren't being enforced? No condition on allow_list_bucket.
  s3_shared_read_account_principals = jsonencode(
    {"AWS"=[
      "arn:aws:iam::714474267469:root",
      "arn:aws:iam::742629497219:root"
    ]}
  )

  # I'm surprised it let's me do this as there is no AWSPowerUser role in Kinaida.
  s3_shared_write_action_condition = jsonencode(
    {"ForAnyValue:ArnLike":{"aws:PrincipalArn": [
      "arn:aws:iam::714474267469:role/AWSPowerUser",
    ]}}
  )

  # arn:aws:iam::742629497219:role/ec2-role - even though I removed the role, it still let's me read the bucket. No condition on allow_list_bucket.
  #s3_shared_read_action_condition = jsonencode(
  #  {"ForAnyValue:ArnLike":{"aws:PrincipalArn": [
  #    "arn:aws:iam::742629497219:role/ec2-role"
  #  ]}}
  #)
  s3_shared_read_action_condition = jsonencode(
    {"ForAnyValue:ArnLike":{"aws:PrincipalArn": [
      "arn:aws:iam::742629497219:role/ec2_role"
    ]}}
  )

}

module "kinaida_shared_bucket" {
  source = "../../modules/s3_secure"

  #sse_setting = "sse-s3"
  sse_setting = "sse-kms-cmk"
  sse_s3_kms_key_arn = aws_kms_key.cmk.arn
  bucket_name = "kinaida-share"

  allow_get_bucket_location = true
  grant_allow_get_bucket_location_to_principal = local.s3_shared_read_account_principals
  get_bucket_location_condition = local.s3_shared_read_action_condition

  allow_put_object = true
  grant_allow_put_object_to_principal = local.s3_shared_write_account_principals
  put_object_condition = local.s3_shared_write_action_condition

  allow_get_object = true
  grant_allow_get_object_to_principal =  local.s3_shared_read_account_principals
  get_object_condition = local.s3_shared_read_action_condition

  allow_list_bucket = true
  grant_allow_list_bucket_to_principal = local.s3_shared_read_account_principals
  # no allow_list_bucket condition

  #tags = local.db_backup_restore_bucket_tags
}
