# disabled mapping fail to delete. Even terraform destroy.
# aws lambda  delete-event-source-mapping --uuid {{ uuid }}

# api_gateway writes to r_queue
resource "aws_sqs_queue" "r_queue" {
  name                        = "r_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

#resource "aws_lambda_event_source_mapping" "r_queue_call_db" {
#  event_source_arn = aws_sqs_queue.r_queue.arn
#  function_name = aws_lambda_function.sqs_trigger.arn
#}

#resource "aws_sqs_queue" "s_queue" {
#  name                        = "s_queue.fifo"
#  fifo_queue                  = true
#  content_based_deduplication = true
#}

resource "aws_lambda_event_source_mapping" "r_queue_call_jira" {
  event_source_arn = aws_sqs_queue.r_queue.arn
  function_name = aws_lambda_function.jira_trigger.arn
}

resource "aws_sqs_queue" "t_queue" {
  name                        = "t_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "t_queue_call_slack_welcome" {
  event_source_arn = aws_sqs_queue.t_queue.arn
  function_name = aws_lambda_function.slack_trigger.arn
}

resource "aws_sqs_queue" "u_queue" {
  name                        = "u_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "u_queue_call_otp" {
  event_source_arn = aws_sqs_queue.u_queue.arn
  function_name = aws_lambda_function.otp_trigger.arn
}

resource "aws_sqs_queue" "v_queue" {
  name                        = "v_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "v_queue_call_slack_update" {
  event_source_arn = aws_sqs_queue.v_queue.arn
  function_name = aws_lambda_function.slack_update_trigger.arn
}

resource "aws_sqs_queue" "w_queue" {
  name                        = "w_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "w_queue_call_jira_update" {
  event_source_arn = aws_sqs_queue.w_queue.arn
  function_name = aws_lambda_function.jira_update_trigger.arn
}

