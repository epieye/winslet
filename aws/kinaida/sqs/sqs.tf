resource "aws_sqs_queue" "kinaida_sqs_queue" {
  name                        = "kindaida_sqs_queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

