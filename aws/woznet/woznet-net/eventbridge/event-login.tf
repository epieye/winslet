resource "aws_lambda_function" "login_trigger" {
  filename = "lambdas/login_trigger.zip"
  function_name = "login_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = "${aws_cloudwatch_event_rule.capture-aws-sign-in.name}" # try it without the "${}"
  target_id = "login_trigger"
  arn = aws_lambda_function.login_trigger.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.capture-aws-sign-in.arn
}

