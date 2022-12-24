resource "aws_lambda_function" "excel_lambda" {
  filename = "lambdas/excel_lambda.zip"
  function_name = "excel_lambda"
  role = data.terraform_remote_state.iam.outputs.excel_lambda_iam_arn
  handler = "main.lambda_handler"
  runtime = "python3.9"
  timeout = 12
}

