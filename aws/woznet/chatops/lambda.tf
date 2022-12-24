resource "aws_lambda_function" "jira_trigger" {
  filename = "lambdas/jira_trigger.zip"
  function_name = "jira_trigger"
  role = data.terraform_remote_state.iam.outputs.jira_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

resource "aws_lambda_function" "slack_trigger" {
  filename = "lambdas/slack_trigger.zip"
  function_name = "slack_trigger"
  role = data.terraform_remote_state.iam.outputs.slack_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

resource "aws_lambda_function" "otp_trigger" {
  filename = "lambdas/otp_trigger.zip"
  function_name = "otp_trigger"
  role = data.terraform_remote_state.iam.outputs.otp_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

resource "aws_lambda_function" "slack_update_trigger" {
  filename = "lambdas/slack_update_trigger.zip"
  function_name = "slack_update_trigger"
  role = data.terraform_remote_state.iam.outputs.slack_update_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

resource "aws_lambda_function" "jira_update_trigger" {
  filename = "lambdas/jira_update_trigger.zip"
  function_name = "jira_update_trigger"
  role = data.terraform_remote_state.iam.outputs.jira_update_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}


# database lambda, make internal
#resource "aws_lambda_function" "database_trigger" {
#  filename = "lambdas/database_trigger.zip"
#  function_name = "database_trigger"
#  role = data.terraform_remote_state.iam.outputs.database_trigger_iam_arn
#  handler = "main.lambda_handler"
#  runtime = "python3.9"
#  timeout = 12
#}


