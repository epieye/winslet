#resource "aws_iam_access_key" "service_user" {
#  user = aws_iam_user.service_user.name
#}

// This is to put it into secrets manager. access-admin doesn't have permission for this. 
resource "aws_secretsmanager_secret" "service_user_access_key" {
  name = "service-user-access-key"
  description = "NSI Imperva Service User Access Key"
}

// And this creates a version
resource "aws_secretsmanager_secret_version" "service_user_access_key" {
  secret_id     = "${aws_secretsmanager_secret.service_user_access_key.id}"
  secret_string = jsonencode({
    "AccessKey" = data.terraform_remote_state.woznet-iam-iam.outputs.service_user_id,
    "SecretAccessKey" = data.terraform_remote_state.woznet-iam-iam.outputs.service_user_secret
  })
}

//
//    "AccessKey" = data.terraform_remote_state.nsi_iam.outputs.service_user_id,
//    "SecretAccessKey" = data.terraform_remote_state.nsi_iam.outputs.imperva_service_user_secret


#output "service_user_id" {                                 
#  value       = aws_iam_access_key.service_user.id
#  description = "user key id."
#  sensitive   = true
#}
#
#output "service_user_secret" {
#  value       = aws_iam_access_key.service_user.secret
#  description = "user secret."
#  sensitive   = true
#}
#
#-- !376 top level
#
#// access admin 
#resource "aws_secretsmanager_secret" "octopus_service_user_access_key" {
#  name = "octopus-service-user-access-key"
#  description = "Lab Octopus Service User Access Key"
#}
#
#resource "aws_secretsmanager_secret_version" "octopus_service_user_access_key" {
#  secret_id     = "${aws_secretsmanager_secret.octopus_service_user_access_key.id}"
#  secret_string = jsonencode({"AccessKey" = data.terraform_remote_state.iam.outputs.octopus_service_user_id, "SecretAccessKey" = data.terraform_remote_state.iam.outputs.octopus_service_user_secret})
#}
