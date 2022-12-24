resource "aws_cloudwatch_log_group" "yada" {
  name = "Yada"

  #tags = {
  #  Environment = "production"
  #  Application = "serviceA"
  #}
}


resource "aws_cloudwatch_log_stream" "foo" {
  name           = "SampleLogStream1234"
  log_group_name = aws_cloudwatch_log_group.yada.name
}
