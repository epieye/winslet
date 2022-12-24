# also see secure_s3
# I'm not sure I want to trouble myself with it
# But I really have to understand iam roles and policies.

resource "aws_s3_bucket" "main_bucket" {
  bucket = var.tags["Name"]
  acl    = "private"
  policy = var.policy
  tags = var.tags
}

output "bucket_id" {
  value = aws_s3_bucket.main_bucket.id
}

