resource "aws_s3_bucket" "main_bucket" {
  bucket = var.tags["Name"]
  acl    = "private"
  policy = var.policy
  tags = var.tags
}

output "bucket_id" {
  value = aws_s3_bucket.main_bucket.id
}

