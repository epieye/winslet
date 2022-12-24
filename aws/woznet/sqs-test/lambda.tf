resource "aws_lambda_function" "test_trigger" {
  filename = "lambdas/test_trigger.zip"
  function_name = "test_trigger"
  role = data.terraform_remote_state.iam.outputs.test_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

resource "aws_lambda_function" "next_trigger" {
  filename = "lambdas/next_trigger.zip"
  function_name = "next_trigger"
  role = data.terraform_remote_state.iam.outputs.next_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

