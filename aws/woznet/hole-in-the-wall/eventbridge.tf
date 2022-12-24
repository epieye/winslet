## rename sqs_trigger to database_trigger or something
#resource "aws_lambda_function" "sqs_trigger" {
#  filename = "lambdas/sqs_trigger.zip"
#  function_name = "sqs_trigger"
#  role = data.terraform_remote_state.iam.outputs.event_bridge_arn
#  handler = "main.lambda_handler"
#  runtime = "python3.9"
#  timeout = 6
#  vpc_config {
#    subnet_ids         = [module.chatops.public_subnet_ids[0],
#                          module.chatops.public_subnet_ids[1]]
#    security_group_ids = [module.chatops_sg.id]
#  }
#
#}
#
#resource "aws_cloudwatch_event_target" "lambda_sqs" {
#  rule = aws_cloudwatch_event_rule.incoming-sqs.name
#  target_id = "sqs_trigger"
#  arn = aws_lambda_function.sqs_trigger.arn
#}
#
#resource "aws_lambda_permission" "allow_lambda4sqs" {
#  statement_id = "AllowExecutionFromCloudWatchAndExecuteLambda4sqs"
#  action = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.sqs_trigger.arn
#  principal = "events.amazonaws.com"
#  source_arn = aws_cloudwatch_event_rule.incoming-sqs.arn
#}
#
## Do I need this now? Firing directly from SQS queue.
#resource "aws_cloudwatch_event_rule" "incoming-sqs" {
#  name        = "incoming-sqs"
#  description = "Trigger on SQS Events"
#
#  event_pattern = <<EOF
#{
#  "source": ["aws.sqs"]
#}
#EOF
#}
#
## create a VPC endpoint so the lambda in my VPC can connect to secrets manager / sqs 
#resource "aws_vpc_endpoint" "sqs_service" {
#  vpc_id            = module.chatops.vpc_id
#  service_name      = "com.amazonaws.us-east-1.sqs"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    module.chatops.public_subnet_ids[0],
#    module.chatops.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    module.chatops_sg.id
#  ]
#
#  private_dns_enabled = true
#}

#resource "aws_vpc_endpoint" "secret_service" {   
#  vpc_id            = module.chatops.vpc_id
#  service_name      = "com.amazonaws.us-east-1.secretsmanager"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    module.chatops.public_subnet_ids[0],
#    module.chatops.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    module.chatops_sg.id
#  ]
#
#  private_dns_enabled = true
#}
