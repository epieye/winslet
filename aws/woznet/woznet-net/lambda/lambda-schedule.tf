# It's not calling the code from s3. Is that right?
# no: The deployment package of your Lambda function "ScratchyCooPark4" is too large to enable inline code editing. However, you can still invoke your function.
# 
# I added Krakatoa manually. Figure out how to create that in terraform.
# rule: existingRules
# Rule: arn:aws:events:us-east-1:742629497219:rule/Krakatoa
# selectedRuleType: scheduleExpression
#
# Your function doesn't have permission to write to Amazon CloudWatch Logs. 
# To view logs, add the AWSLambdaBasicExecutionRole managed policy to its execution role. Open the IAM console

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#resource "aws_iam_role" "iam_for_lambda" {
#  name = "iam_for_lambda"
#
#  assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": "secretsmanager:GetSecretValue",
#            "Resource": "*"
#        }
#    ]
#}
#EOF
#}


#resource "aws_iam_role" "ec2_iam_role" {
#  name = "ec2_iam_role"
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Principal": {
#        "Service": [
#          "ec2.amazonaws.com"
#        ]
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
#    role = "${aws_iam_role.ec2_iam_role.name}"
#    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
#}

resource "aws_iam_role_policy" "allow_lambda_access_secrets" {
  name = "allow_lambda_access_secrets"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



#resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
#    role = "${aws_iam_role.iam_for_lambda.name}" # why is this like this? Why can't it just be "aws_iam_role.iam_for_lambda.name" ?
#    #policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
#    policy_arn = aws_iam_role_policy.allow_access_secrets.arn
#}



#resource "aws_iam_role_policy" "test_policy" {
#  name = "test_policy"
#  role = aws_iam_role.test_role.id
#
#  # Terraform's "jsonencode" function converts a
#  # Terraform expression result to valid JSON syntax.
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = [
#          "ec2:Describe*",
#        ]
#        Effect   = "Allow"
#        Resource = "*"
#      },
#    ]
#  })
#}





#resource "aws_iam_role_policy" "api-invoker" {
#    provider = <some provider>
#    role     = aws_iam_role.api-invoker.id
#    policy   = data.aws_iam_policy_document.execute-api.json
#}
#
#data "aws_iam_policy_document" "execute-api" {
#    statement {
#     sid = "all"
#     actions = [
#       "execute-api:*",
#     ]
#     resources = [
#       "*"
#     ]
#   }
#}




# So what does the above actually do?
# allow the lambda to access secretsmanager
# Limit this to the resource arn in question 
#
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#          "Effect": "Allow",
#          "Action": [
#              "secretsmanager:*"
#            ],
#          "Resource": [
#            "*"
#          ]
#        }
#    ]
#}
# "secretsmanager.amazonaws.com"

resource "aws_lambda_function" "scratchycoopark4" {
    filename = "lambdas/test.zip"
    function_name = "ScratchyCooPark4"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "main.lambda_handler"
    #source_code_hash = filebase64sha256("lambdas/test.zip")
    runtime = "python3.9"
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
    name = "every-hour"
    description = "Fires every hour"
    schedule_expression = "rate(2 days)"
}

resource "aws_cloudwatch_event_target" "scratchycoopark4_every_five_minutes" {
    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
    target_id = "scratchycoopark4"
    arn = "${aws_lambda_function.scratchycoopark4.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_scratchycoopark4" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.scratchycoopark4.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
}

output "scratchycoopark4" {
  value = aws_lambda_function.scratchycoopark4
}

