# disabled mapping fail to delete. Even terraform destroy.
# aws lambda  delete-event-source-mapping --uuid {{ uuid }}

resource "aws_sqs_queue" "test_queue" {
  name                        = "test_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "test_queue" {
  event_source_arn = aws_sqs_queue.test_queue.arn
  function_name = aws_lambda_function.test_trigger.arn
}

resource "aws_sqs_queue" "next_queue" {
  name                        = "next_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_lambda_event_source_mapping" "next_queue" {
  event_source_arn = aws_sqs_queue.test_queue.arn
  function_name = aws_lambda_function.next_trigger.arn
}
