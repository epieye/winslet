resource "aws_lambda_function" "r53_trigger" {
  filename = "lambdas/r53_trigger.zip"
  function_name = "r53_trigger"
  role = aws_iam_role.iam_for_eventbridge.arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

// roles and rules are defined in their own files now
resource "aws_cloudwatch_event_target" "lambda_r53" {
  rule = "${aws_cloudwatch_event_rule.changes-r53.name}" # try it without the "${}"
  target_id = "r53_trigger"
  arn = aws_lambda_function.r53_trigger.arn
}

resource "aws_lambda_permission" "allow_lambda4r53" {
  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4Rds"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r53_trigger.arn
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.changes-r53.arn
}
