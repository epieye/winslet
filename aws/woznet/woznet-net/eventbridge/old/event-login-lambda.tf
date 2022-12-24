#// 
#// Based on sns "test" example. Just want to trigger a lambda instead. Just. lol.
#// Wait. Did this actually effing work? Why did it send it twice?
#
#resource "aws_cloudwatch_event_rule" "console2" {
#  name        = "capture-aws-sign-in"
#  description = "Capture each AWS Console Sign In"
#
#  event_pattern = <<EOF
#{
#  "detail-type": [
#    "AWS Console Sign In via CloudTrail"
#  ]
#}
#EOF
#}
#
##resource "aws_cloudwatch_event_target" "sns" {
##  rule      = aws_cloudwatch_event_rule.console2.name
##  target_id = "SendToSNS"
##  arn       = aws_sns_topic.aws_logins.arn
##}
#
#resource "aws_cloudwatch_event_target" "lambda" {
#  rule = "${aws_cloudwatch_event_rule.console.name}" # try it without the ${}
#  target_id = "scratchycoopark4"
#  #arn = "${aws_lambda_function.scratchycoopark4.arn}"
#  arn = data.terraform_remote_state.woznet-lambda.outputs.scratchycoopark4.arn
#}
#
#// this and/xor aws_sns_topic_policy+aws_iam_policy_document?
#resource "aws_lambda_permission" "allow_cloudwatch_to_call_scratchycoopark4" {
#    statement_id = "AllowExecutionFromCloudWatch2" # Is this just a label with no real meaning? Perhaps reuse other permission?
#    action = "lambda:InvokeFunction"
##    function_name = "${aws_lambda_function.scratchycoopark4.function_name}"
#    function_name = data.terraform_remote_state.woznet-lambda.outputs.scratchycoopark4.function_name
#    principal = "events.amazonaws.com"
##    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
#    source_arn = aws_cloudwatch_event_rule.console2.arn
#}
#
##resource "aws_sns_topic" "aws_logins" {
##  name = "aws-console-logins"
##}
##
##resource "aws_sns_topic_policy" "default" {
##  arn    = aws_sns_topic.aws_logins.arn
##  policy = data.aws_iam_policy_document.sns_topic_policy.json
##}
##
##data "aws_iam_policy_document" "sns_topic_policy" {
##  statement {
##    effect  = "Allow"
##    actions = ["SNS:Publish"]
##
##    principals {
##      type        = "Service"
##      identifiers = ["events.amazonaws.com"]
##    }
##
##    resources = [aws_sns_topic.aws_logins.arn]
##  }
##}
#
