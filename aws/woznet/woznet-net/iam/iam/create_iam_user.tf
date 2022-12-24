resource "aws_iam_user" "service_user" {
  name = "service-user"
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

// Presumably this creates the access and secret keys.
resource "aws_iam_access_key" "service_user" {
  user = aws_iam_user.service_user.name
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

#-- ! 376 iam subdir
#
#// Power User cannot create the IAM user. 
#resource "aws_iam_user" "service_user" {
#  name = "service-user"
#}
#
#// I had to split this into two. 
#resource "aws_iam_user_policy_attachment" "service_user" {
#  user       = aws_iam_user.service_user.name
#  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
#}
#
#// Presumably this creates the access key, but not the secret key.
#resource "aws_iam_access_key" "service_user" {
#  user = aws_iam_user.service_user.name
#}
#
#// Output the user ID and secret so we can use it in the top level
#output "service_user_id" {
#  value       = aws_iam_access_key.service_user.id
#  description = "The service user key id."
#  sensitive   = true
#}
#output "service_user_secret" {
#  value       = aws_iam_access_key.service_user.secret
#  description = "The service user secret."
#  sensitive   = true
#}

