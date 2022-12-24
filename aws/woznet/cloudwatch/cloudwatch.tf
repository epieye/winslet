#
# Can I add this to the terraform file, or can I only do it on the command line?
# terraform import aws_cloudwatch_log_group.Diophantus /aws/lambda/Diophantus
#

resource "aws_cloudwatch_log_group" "Diophantus" {
  retention_in_days = 30
}

#terraform import aws_cloudwatch_log_group.Eratosthenes /aws/lambda/Eratosthenes
resource "aws_cloudwatch_log_group" "Eratosthenes" {
  retention_in_days = 30
}

# terraform import aws_cloudwatch_log_group.Eudoxus /aws/lambda/Eudoxus
resource "aws_cloudwatch_log_group" "Eudoxus" {
  retention_in_days = 30
}


