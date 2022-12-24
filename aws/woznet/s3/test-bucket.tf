locals {
  trusted_account_principals = jsonencode({"AWS"=["arn:aws:iam::697672003593:root"]})

  # But I don't have any roles. Ugh. Oh that's why I can't test it.
  action_condition = jsonencode({"ForAnyValue:ArnLike":{"aws:PrincipalArn": ["arn:aws:iam::*:role/*AWSPowerUserAccess*","arn:aws:iam::*:role/*AnsibleRunner*"]}})
}

module "datascan-panorama-backup" {
  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//s3_secure"

  sse_setting = "sse-s3"

  bucket_name = "ourzoo-test-bucket"

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
      Name = "ourzoo-test-bucket"
    }
}

output "" {
  value = module.network_test_bucket.
}

