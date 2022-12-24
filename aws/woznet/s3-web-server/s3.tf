# 742629497219 = ourzoo-root

locals {
  trusted_account_principals = jsonencode({"AWS"=["arn:aws:iam::742629497219:root"]})
  action_condition = jsonencode({"ForAnyValue:ArnLike":{"aws:PrincipalArn": ["arn:aws:iam::*:role/*AWSPowerUserAccess*","arn:aws:iam::*:role/*AnsibleRunner*"]}})
}

module "network_test_dev_bucket" {
  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//s3_secure"
  source = "./temp_modules_s3_secure"

  sse_setting = "sse-s3"
  bucket_name = "network-test-dev.kinaida.net"

  acl = "public-read"
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false

  allow_get_bucket_location = true
  grant_allow_get_bucket_location_to_principal = local.trusted_account_principals
  get_bucket_location_condition = local.action_condition

  allow_put_object = true
  grant_allow_put_object_to_principal = local.trusted_account_principals
  put_object_condition = local.action_condition

  allow_get_object = true
  grant_allow_get_object_to_principal =  local.trusted_account_principals
  get_object_condition = local.action_condition

  allow_list_bucket = true
  grant_allow_list_bucket_to_principal = local.trusted_account_principals

  tags = {
      Name = "network-test-dev.kinaida.net"
    }
}
