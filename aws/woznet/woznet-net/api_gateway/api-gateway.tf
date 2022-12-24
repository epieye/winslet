# https://javascript.plainenglish.io/deploy-api-gateway-lambda-and-dynamodb-using-terraform-3bb2154e92ff
# https://levelup.gitconnected.com/deploy-lambda-function-and-api-gateway-using-terraform-d12cdc50dee8

# This bit me again
# https://aws.amazon.com/premiumsupport/knowledge-center/api-gateway-rest-api-lambda-integrations/
# To add Lambda invoke permission to a REST API with a Lambda integration using the API Gateway console
# How can I do this in Integration request?

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  managed_policy_arns   =  [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com", "lambda.amazonaws.com", "ssm.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "allow_lambda_access_secrets" {
  name = "allow_lambda_access_secrets"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue*"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:us-east-1:742629497219:secret:bob-OqnbKd"
      },
      {
        Action = [
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "rds-db:connect"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "lambda:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "sqs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#"ec2:DescribeNetworkInterfaces",
#"ec2:CreateNetworkInterface",
#"ec2:DeleteNetworkInterface",
#"ec2:DescribeInstances",
#"ec2:AttachNetworkInterface"
#ec2:DescribeSecurityGroups
#ec2:DescribeSubnets
#ec2:DescribeVpcs
# lambda:VpcIds – Allow or deny one or more VPCs.
#lambda:SubnetIds – Allow or deny one or more subnets.
#lambda:SecurityGroupIds – Allow or deny one or more security groups.

resource "aws_lambda_function" "Eratosthenes" {
  filename = "lambdas/test.zip"
  function_name = "Eratosthenes" 
  role = aws_iam_role.iam_for_lambda.arn
  timeout = 12
  handler = "main.lambda_handler"
  runtime = "python3.8"
  #vpc_config {
  #  subnet_ids         = [data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[0],
  #                        data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[1]]
  #  security_group_ids = [data.terraform_remote_state.woznet.outputs.woznet_sg.id]
  #}
}

resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "Eratosthenes-Api"

  #endpoint_configuration {
  #  types = ["REGIONAL"]
  #}
}

resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "myresource"

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
   type                    = "AWS_PROXY"  # Lambda?
   uri                     = aws_lambda_function.Eratosthenes.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [aws_api_gateway_integration.lambdaInt]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "Prod"
}

resource "aws_lambda_permission" "apigw" {
   function_name = aws_lambda_function.Eratosthenes.function_name
   source_arn    = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/Prod/POST/myresource"
   principal     = "apigateway.amazonaws.com"
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
}

## create a VPC endpoint so the lambda in my VPC can connect to secrets manager
#resource "aws_vpc_endpoint" "secrets_manager" {
#  vpc_id            = data.terraform_remote_state.woznet.outputs.woznet_settings.vpc_id
#  service_name      = "com.amazonaws.us-east-1.secretsmanager"
#  vpc_endpoint_type = "Interface"
#
#  subnet_ids        = [
#    data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[0],
#    data.terraform_remote_state.woznet.outputs.woznet_settings.public_subnet_ids[1]
#  ]
#
#  security_group_ids = [
#    data.terraform_remote_state.woznet.outputs.woznet_sg.id
#  ]
#
#  private_dns_enabled = true
#}

# AWS recommends a nat gateway for external connectivity rather than the internet gateway. Why?
# https://stackoverflow.com/questions/52992085/why-cant-an-aws-lambda-function-inside-a-public-subnet-in-a-vpc-connect-to-the“
# Also nat gateway requires an elastic IP, and I've got to pay for that. 
# But let'a try it and see if it fixes the issue with lambda getting to slack.
# design - multiple lambdas just for what I need. Maybe rabbit. 
# resources: events, database, external connectivity (incoming and outgoing)

# I also clicked on it in the GUI and enabled <- 

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}

