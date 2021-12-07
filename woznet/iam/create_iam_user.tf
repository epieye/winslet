resource "aws_iam_user" "service_user" {
  name = "service-user"
}

// Create api access only. 
// console password is disabled. Summary User does not have console management access - perfect!

resource "aws_iam_access_key" "service_user" {
  user = aws_iam_user.service_user.name
}

resource "aws_iam_policy" "service_user_policy" {
  name        = "test"
  description = "Just testing"
  policy      = file("${path.module}/policies/service_user_policy.json")
}

resource "aws_iam_user_policy_attachment" "service_user" {
  user       = aws_iam_user.service_user.name
  policy_arn = aws_iam_policy.service_user_policy.arn
}

output "service_user_id" {
  value       = aws_iam_access_key.service_user.id
  description = "user key id."
  sensitive   = true
}

output "service_user_secret" {
  value       = aws_iam_access_key.service_user.secret
  description = "user secret."
  sensitive   = true
}
