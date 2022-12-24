resource "aws_lambda_function" "hole_in_the_wall_trigger" {
  filename = "lambdas/hole_in_the_wall_trigger.zip"
  function_name = "hole_in_the_wall_trigger"
  role = data.terraform_remote_state.iam.outputs.hole_in_the_wall_trigger_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 6
  vpc_config {
    subnet_ids         = [module.hole_in_the_wall.public_subnet_ids[0],
                          module.hole_in_the_wall.public_subnet_ids[1]]
    security_group_ids = [module.hole_in_the_wall_sg.id]
  }

}


# I'm not triggering this lambda on an event, just run daily or even weekly


#resource "aws_cloudwatch_event_target" "lambda_hole_in_the_wall" {
#  rule = aws_cloudwatch_event_rule.incoming-hole_in_the_wall.name
#  target_id = "hole_in_the_wall_trigger"
#  arn = aws_lambda_function.hole_in_the_wall_trigger.arn
#}

#resource "aws_lambda_permission" "allow_lambda4hole_in_the_wall" {
#  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4hole_in_the_wall"
#  action = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.hole_in_the_wall_trigger.arn
#  principal = "events.amazonaws.com"
#  source_arn = aws_cloudwatch_event_rule.incoming-hole_in_the_wall.arn
#}
