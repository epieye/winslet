resource "aws_iam_role" "holeinthewallRole" {
  name = "holeinthewallRole"

  managed_policy_arns   =  [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Eudoxus",                <-
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com", "lambda.amazonaws.com"]
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "allow_lambda_access" {
  name = "allow_lambda_access_for_holeinthewall"
  role = aws_iam_role.holeinthewallRole.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
      #,
      #{
      #  Action = [
      #    "ec2:DescribeNetworkInterfaces",
      #    "ec2:CreateNetworkInterface",
      #    "ec2:DeleteNetworkInterface",
      #    "ec2:DescribeInstances",
      #    "ec2:AttachNetworkInterface",
      #    "ec2:DescribeSecurityGroups",
      #    "ec2:DescribeSubnets",
      #    "ec2:DescribeVpcs"
      #  ]
      #  Effect   = "Allow"
      #  Resource = "*"
      #},
      #{
      #  Action = [
      #    "rds:*"
      #  ]
      #  Effect   = "Allow"
      #  Resource = "*"
      #},
      #{
      #  Action = [
      #    "rds-db:connect"
      #  ]
      #  Effect   = "Allow"
      #  Resource = "*"
      #},
      #{
      #  Action = [
      #    "lambda:*"
      #  ]
      #  Effect   = "Allow"
      #  Resource = "*"
      #}
    ]
  })
}


resource "aws_lambda_function" "Eudoxus" {     <-
  filename = "lambdas/demo.zip"                <-
  function_name = "Eudoxus"                    <-
  role = aws_iam_role.holeinthewallRole.arn
  timeout = 12
  handler = "main.lambda_handler"
  runtime = "python3.9"
  #vpc_config {
  #  subnet_ids         = [module.holeinthewall.public_subnet_ids[0],
  #                        module.holeinthewall.public_subnet_ids[1]]
  #  security_group_ids = [module.holeinthewall_sg.id]
  #}

}

resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "Eudoxus-Api",                      <-

  "endpointConfiguration": {
    "types": "PRIVATE"
  }
}

resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "ask_wozbot"
}

resource "aws_api_gateway_method" "Method" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.Resource.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambdaInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.Resource.id
   http_method = aws_api_gateway_method.Method.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Eudoxus.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [aws_api_gateway_integration.lambdaInt]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "Prod"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Eudoxus.function_name
   principal     = "apigateway.amazonaws.com"
   #source_arn    = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/Prod/POST/ask_wozbot" 
   source_arn    = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}

## create a VPC endpoint so the lambda in my VPC can connect to secrets manager
#resource "aws_vpc_endpoint" "secrets_manager" {
#  vpc_id            = module.holeinthewall.vpc_id
#  service_name      = "com.amazonaws.us-east-1.secretsmanager"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    module.holeinthewall.public_subnet_ids[0],
#    module.holeinthewall.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    module.holeinthewall_sg.id
#  ]
#
#  private_dns_enabled = true
#}

output "api_gateway" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}

#output "" {
#  value = aws_lambda_function.Eudoxus.
#}
