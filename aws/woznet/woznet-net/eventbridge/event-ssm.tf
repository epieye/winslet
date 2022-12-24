resource "aws_lambda_function" "ssm_trigger" {
  filename = "lambdas/ssm_trigger.zip"
  function_name = "ssm_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_ssm" {
  rule = "${aws_cloudwatch_event_rule.changes-ssm.name}" # try it without the "${}"
  target_id = "ssm_trigger"
  arn = aws_lambda_function.ssm_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4ssm" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ssm_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-ssm.arn
}

