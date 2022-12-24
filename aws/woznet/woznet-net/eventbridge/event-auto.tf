resource "aws_lambda_function" "auto_trigger" {
  filename = "lambdas/auto_trigger.zip"
  function_name = "auto_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_auto" {
  rule = "${aws_cloudwatch_event_rule.changes-auto.name}" # try it without the "${}"
  target_id = "auto_trigger"
  arn = aws_lambda_function.auto_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4auto" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-auto.arn
}
