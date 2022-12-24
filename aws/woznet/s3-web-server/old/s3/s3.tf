locals {
  trusted_account_principals = jsonencode({"AWS"=["arn:aws:iam::977978523652:root"]})
  action_condition = jsonencode({"ForAnyValue:ArnLike":{"aws:PrincipalArn": ["arn:aws:iam::*:role/*AWSPowerUserAccess*","arn:aws:iam::*:role/*AnsibleRunner*"]}})
}

module "network_test_bucket" {
  #source = "git::ssh://git@git.onedatascan.io:2222/cloudops/aws-tf.git//s3_secure"
  source = "../../../modules/s3_secure"

  # get_object_condition ??


  # I commented out the BucketOwnerEnforced in the module so 'acl = "public-read"' doesn't throw an error. 
  # But then I get Access Denied trying to write the index.html file to the bucket. Makes sense as I've turned off BucketOwner
  # Try hard coding AWSPowerUserAccess ARN to the put objext policy? Too messy. Wait and talk to Josh.
  acl = "public-read"

  block_public_acls = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  sse_setting = "sse-s3"
  bucket_name = "network-test-dev.kinaida.net"

  allow_get_bucket_location = true
  grant_allow_get_bucket_location_to_principal = local.trusted_account_principals

  allow_put_object = true
  grant_allow_put_object_to_principal = local.trusted_account_principals

  allow_get_object = true
  grant_allow_get_object_to_principal =  local.trusted_account_principals

  #allow_public_get_object = true # s3-based webservers only
  ##grant_allow_public_get_object_to_principal = "*"

  allow_list_bucket = true
  grant_allow_list_bucket_to_principal = local.trusted_account_principals
}

output "target_bucket" {
  value = module.network_test_bucket.target_bucket
}
