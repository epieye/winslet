// It just seems a bit easy. 
// detail-type seems to be the only useful piece, but looks so free form.
// Can I make it (say) "AWS Route53 ChangeResourceRecordSets via CloudTrail" ? Do I have to set up CloudTrail?

resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-aws-sign-in"
  description = "Capture each AWS Console Sign In"

  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ]
}
EOF
}






resource "aws_cloudwatch_event_target" "                               " {       #<- 
  arn = module.                        .lambda_function_arn
  rule = aws_cloudwatch_event_rule.                                   .name      #<-   console above
}







// This looks very much what I have in the lambda/ subdir 
// event rather than lambda or s3 or ec2 ??
resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
#  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
#  function_name = module.profile_generator_lambda.lambda_function_name
#  principal = "events.amazonaws.com"
#  source_arn = aws_cloudwatch_event_rule.profile_generator_lambda_event_rule.arn
}

