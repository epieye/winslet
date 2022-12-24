# test this
# curl -k -X POST https://hc5e6qorh3.execute-api.us-east-1.amazonaws.com/Prod/network_test -d {"this":"that"}

resource "aws_lambda_function" "network_test" {
  filename = "lambdas/network_test.zip"
  function_name = "network_test" 
  role = data.terraform_remote_state.iam.outputs.network_test_arn
  timeout = 12
  handler = "main.lambda_handler"
  runtime = "python3.9"
}

resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "network_test-Api"
}

resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "network_test"
}

resource "aws_api_gateway_method" "Method" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.Resource.id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambdaInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.Resource.id
   http_method = aws_api_gateway_method.Method.http_method

   integration_http_method = "GET"
   type                    = "AWS"
   uri                     = aws_lambda_function.network_test.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [aws_api_gateway_integration.lambdaInt]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "Prod"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.network_test.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn    = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}

output "network_test_api_gateway" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}
