locals {
  output_lambda_zip = "${var.lambda_source_dir}/../${basename(var.lambda_source_dir)}.zip"
}

data "archive_file" "lambda_my_function" {
  type             = "zip"
  source_dir       = var.lambda_source_dir
  output_file_mode = "0666"
  output_path      = local.output_lambda_zip
}

resource "aws_lambda_function" "lambda" {
  filename      = local.output_lambda_zip
  function_name = var.tags["Name"]
  role          = var.iam_role_arn
  handler       = var.handler
  description   = var.description
  source_code_hash = filebase64sha256(local.output_lambda_zip)

  runtime = var.runtime

  environment {
    variables = var.environment
  }
}

resource "aws_cloudwatch_event_rule" "rule" {
  count = length(var.schedule_expression) > 0 ? 1 : 0

  name        = "${var.tags["Name"]}_trigger"
  schedule_expression    = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "target" {
  count = length(var.schedule_expression) > 0 ? 1 : 0

  rule      = aws_cloudwatch_event_rule.rule[0].name
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count = length(var.schedule_expression) > 0 ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule[0].arn
}
