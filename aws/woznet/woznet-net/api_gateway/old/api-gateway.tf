## examplepy is now ourzoo
#resource "aws_api_gateway_rest_api" "ourzoo" {
#  name        = "Ourzoo"
#  description = "Terraform Serverless Application Example python"
#
#  endpoint_configuration {
#    types = ["REGIONAL"]
#  }
#}
#
##resource "aws_api_gateway_rest_api" "example" {
##  name = "example"
##}
#
## aws_api_gateway_resource "number" is now bob
#resource "aws_api_gateway_resource" "bob" {
#  parent_id   = aws_api_gateway_rest_api.ourzoo.root_resource_id
#  rest_api_id = aws_api_gateway_rest_api.ourzoo.id
#  #path_part   = "{${var.resource_name}+}" # <-- there it is. WTF is "+".
#  path_part   = "example" # Is this like the "helloworld" ?
#  
#}
#
##resource "aws_api_gateway_resource" "example" {
##  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
##  path_part   = "example"
##  rest_api_id = aws_api_gateway_rest_api.example.id
##}
#
#resource "aws_api_gateway_method" "bob" {
#   rest_api_id   = aws_api_gateway_rest_api.ourzoo.id
#   resource_id   = aws_api_gateway_resource.bob.id
#   http_method   = "GET"
#   authorization = "NONE"
#}
#
##resource "aws_api_gateway_method" "example" {
##  authorization = "NONE"
##  http_method   = "GET"
##  resource_id   = aws_api_gateway_resource.example.id
##  rest_api_id   = aws_api_gateway_rest_api.example.id
##}
#
##resource "aws_api_gateway_integration" "lambdapy" {
##   rest_api_id = aws_api_gateway_rest_api.ourzoo.id
##   resource_id = aws_api_gateway_method.bob.resource_id
##   http_method = aws_api_gateway_method.bob.http_method
##
##   integration_http_method = "POST"
##   type                    = "AWS"
##   uri                     = aws_lambda_function.examplepy.invoke_arn
##   passthrough_behavior = "WHEN_NO_TEMPLATES"
##   
###   request_templates = {
###    "application/json" = <<EOF
###{
###  "hour" : $input.params('hour')
###  }
###EOF
###  }
##}
#
#resource "aws_api_gateway_integration" "bob" {
#  http_method = aws_api_gateway_method.bob.http_method
#  resource_id = aws_api_gateway_resource.bob.id
#  rest_api_id = aws_api_gateway_rest_api.ourzoo.id
#  type        = "AWS"
#}
#
### Is this an additional method? I don't want an extra one.
##resource "aws_api_gateway_method" "number_rootpy" {
##   rest_api_id   = aws_api_gateway_rest_api.examplepy.id
##   resource_id   = aws_api_gateway_rest_api.examplepy.root_resource_id
##   http_method   = "GET"
##   authorization = "NONE"
##}
#
##resource "aws_api_gateway_integration" "lambda_rootpy" {
##   rest_api_id = aws_api_gateway_rest_api.examplepy.id
##   resource_id = aws_api_gateway_method.number_rootpy.resource_id
##   http_method = aws_api_gateway_method.number_rootpy.http_method
##
##   integration_http_method = "POST"
##   type                    = "AWS"
##   uri                     = aws_lambda_function.examplepy.invoke_arn
###   passthrough_behavior = "WHEN_NO_TEMPLATES"
###   request_templates = {
###    "application/json" = <<EOF
###{"hour" : $input.params('hour')}
###EOF
### }
##}
#
#resource "aws_api_gateway_method_response" "response_200" {
# rest_api_id = aws_api_gateway_rest_api.ourzoo.id
# resource_id = aws_api_gateway_resource.bob.id
# http_method = aws_api_gateway_method.bob.http_method
# status_code = "200"
# 
# response_models = { "application/json" = "Empty"}
#}
#
#resource "aws_api_gateway_integration_response" "IntegrationResponse" {
#  #depends_on = [
#  #   aws_api_gateway_integration.lambdapy,
#  #   aws_api_gateway_integration.lambda_rootpy,
#  #]
#  rest_api_id = aws_api_gateway_rest_api.ourzoo.id
#  resource_id = aws_api_gateway_resource.bob.id
#  http_method = aws_api_gateway_method.bob.http_method
#  status_code = aws_api_gateway_method_response.response_200.status_code
#  # Transforms the backend JSON response to json. The space is "A must have"
# response_templates = {
# "application/json" = <<EOF
# 
# EOF
# }
#}
#
## Model
## resource "aws_api_gateway_model" "MyDemoModel" {
## rest_api_id = "${aws_api_gateway_rest_api.examplepy.id}"
## name = "usermodel"
## description = "a JSON schema"
## content_type = "application/json"
## 
## #the payload of the POST request
## schema = <<EOF
## {
## "$schema": "http://json-schema.org/draft-04/schema#",
## "title": "usermodel",
## "type": "object",
## "properties": 
## {
## "callerName": { "type": "string" }
## }
## 
## }
## EOF
##}
#
#resource "aws_api_gateway_deployment" "ourzoo" {
#   #depends_on = [
#   #  aws_api_gateway_integration.lambdapy,
#   #  aws_api_gateway_integration_response.IntegrationResponse,
#   #]
#
#   rest_api_id = aws_api_gateway_rest_api.ourzoo.id
#   stage_name  = "test"
#
#}
#
##resource "aws_api_gateway_deployment" "example" {
##  rest_api_id = aws_api_gateway_rest_api.example.id
##
##  triggers = {
##    # NOTE: The configuration below will satisfy ordering considerations,
##    #       but not pick up all future REST API changes. More advanced patterns
##    #       are possible, such as using the filesha1() function against the
##    #       Terraform configuration file(s) or removing the .id references to
##    #       calculate a hash against whole resources. Be aware that using whole
##    #       resources will show a difference after the initial implementation.
##    #       It will stabilize to only change when resources change afterwards.
##    redeployment = sha1(jsonencode([
##      aws_api_gateway_resource.example.id,
##      aws_api_gateway_method.example.id,
##      aws_api_gateway_integration.example.id,
##    ]))
##  }
##
##  lifecycle {
##    create_before_destroy = true
##  }
##}
#
### doesn't exist in other version
##resource "aws_api_gateway_stage" "example" {
##  deployment_id = aws_api_gateway_deployment.example.id
##  rest_api_id   = aws_api_gateway_rest_api.example.id
##  stage_name    = "example"
##}
#
#output "base_url" {
#  value = "${aws_api_gateway_deployment.ourzoo.invoke_url}/${var.resource_name}"
#}
#

resource "aws_api_gateway_rest_api" "example" {
  name = "example"
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "example"
  rest_api_id = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_integration" "example" {
  http_method = aws_api_gateway_method.example.http_method
  resource_id = aws_api_gateway_resource.example.id
  rest_api_id = aws_api_gateway_rest_api.example.id
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.example.id,
      aws_api_gateway_method.example.id,
      aws_api_gateway_integration.example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "example"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}/${var.resource_name}"
}

