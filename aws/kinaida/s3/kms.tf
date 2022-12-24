# create a key to encrypt kinaida-share bucket.

resource "aws_kms_key" "cmk" {
  description             = "KMS Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = { Name = "cmk" }
}

resource "aws_kms_alias" "cmk" {
  name          = "alias/datascan/cmk"
  target_key_id = aws_kms_key.cmk.key_id
}

