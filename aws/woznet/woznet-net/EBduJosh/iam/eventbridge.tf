data "aws_iam_policy_document" "eventbridge_lambda" {
  statement {
    sid       = "AllowLambdaRole"
    actions   = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_for_eventbridge" {
  name = "iam_for_eventbridge"

  managed_policy_arns   = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
  ]

  assume_role_policy = data.aws_iam_policy_document.eventbridge_lambda.json
}

#aws iam attach-role-policy --role-name iam_for_eventbridge --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# It's more than just secrets now
resource "aws_iam_role_policy" "allow_lambda_access_secrets" {
  name = "allow_lambda_access_secrets"
  role = aws_iam_role.iam_for_eventbridge.id

  policy = file("${path.module}/policies/eventbridge.json")
}

# 
#resource "aws_iam_role_policy" "allow_lambda_managed_policy" {
#  name = "allow_lambda_managed_policy"
#  role = aws_iam_role.iam_for_eventbridge.id
#
#  #policy = file("${path.module}/policies/eventbridge.json")
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#  policy 
#}

## Add permission to write to CloudWatch Logs.
#resource "aws_iam_role_policy_attachment" "allow_lambda_managed_policy" {
#  role       = aws_iam_role.iam_for_eventbridge.id
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#}

output "event_bridge_arn" {
  value = aws_iam_role.iam_for_eventbridge.arn
}


# aws iam create-role --role-name lambda-ex --assume-role-policy-document file://trust-policy.json --profile ourzoo-root                               # Allow Lambda AssumeRole
# aws iam attach-role-policy --role-name lambda-ex --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole --profile ourzoo-root # 
# aws iam list-role-policies --role-name iam_for_eventbridge --profile ourzoo-root
# aws iam get-role-policy --role-name lambda-ex --policy-name AWSLambdaBasicExecutionRole --profile ourzoo-root
# aws iam get-role --role-name lambda-ex --profile ourzoo-root
# aws iam get-policy --policy-arn ?? --profile ourzoo-root

# aws iam get-role-policy --role-name iam_for_eventbridge --policy-name allow_lambda_access_secrets --profile ourzoo-root
# Role, policy
# managed policy is separate

#Roles must be assumed by a user or a service.
#Policies outline what can be done (permissions), and these can be attached to roles OR users. 


#IAM Roles are defined as a set of permissions that grant access to actions and resources in AWS. 
#An IAM Role can be used by or assumed by IAM User accounts or by services within AWS, and can give access to Users from another account altogether. 
#IAM Roles are similar to wearing different hats in that they temporarily let an IAM User or a service get permissions to do things they would not normally get to do.  
#These permissions are attached to the Role itself, and are conveyed to anyone or anything that assumes the role. 
#Also, Roles have credentials that can be used to authenticate the Role identity.
#
#You can assign either a pre-built policy or create a custom policy. A policy is something that will be assigned to a role. 
#Admins of the customer environment create an IAM Policy with a constrained set of access, and then assigns that policy to a new Role, specifically assigned to the provider’s Account ID and External ID.  
#When done, the resulting IAM Role is given a specific Amazon Resource Name (ARN), which is a unique string that identifies the role.










