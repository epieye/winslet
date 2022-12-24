// https://medium.com/onfido-tech/aws-api-gateway-with-terraform-7a2bebe8b68f


// creation of the api entry:
resource “aws_api_gateway_rest_api” “api” {
 name = “api-gateway”
 description = “Proxy to handle requests to our API”
}

#   ApiGatewayRestApi:
#    Type: AWS::ApiGateway::RestApi
#    Properties:
#      Name: lambda-api
#      ApiKeySourceType: HEADER
#      Description: An API Gateway with a Lambda Integration
#      EndpointConfiguration:
#        Types:
#          - REGIONAL
#      Policy: >-
#        {"Version": "2012-10-17","Statement": [{"Effect": "Allow","Principal":
#        "*","Action": "execute-api:Invoke","Resource": ["execute-api:/*"]}]}
#      Tags: 
#        - {"Key" : "ODINAPPID_ENV_ROLE_STACK", "Value" : "1117_dev_AWS_Toolbox"}


// Next we will start to configure what we want this API to do:

// This is where we’ll configure on what endpoint are we listening for requests. The path_part argument will contain a string that represents the endpoint path, as our case is a simple proxy, AWS provides a special handler to listen all the requests, the "{proxy+}". This handler can also be applied to a more specific path, i.e "users/{proxy+}" where it will listen to anything starting with users ( i.e users/1/posts , users/3/notes , etc). The other values presented in there are related to where will this resource be applied, the rest_api_id will have the id of what API we are mounting this resource and the parent_id has the id of the parent on where are mounting this. This last one can be mounted directly on the root api (as we have) or mounted in another resource making it a child resource that will be composed by both parent and child. So if you have the path_part defined as "active" in the child resource and it’s mounted in the users resource, the child resource will listen to a users/active endpoint.


resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"                                          # <- 
}

#  ApiGatewayResource:
#    Type: AWS::ApiGateway::Resource
#    Properties:
#      ParentId: !GetAtt ApiGatewayRestApi.RootResourceId
#      PathPart: lambda                     
#      RestApiId: !Ref ApiGatewayRestApi


// In the method resource is were we build the specification of the endpoint we are listening. The http_method argument will have the string with what HTTP method we’re interested, the "ANY" value is, again, a special handler where we’ll accept any HTTP method that comes our way. In the case we have in hands we won’t need any authorization done in our AWS API Gateway, and that’s why the value in authorization is "NONE" . The request_parameters argument, will state that we will have something in a proxy handler required for this method and that will passed to the integration resource (described next).This resource also has some arguments related to where it should be mounted, namely the rest_api_id that is the same as the one described in the Resource resource and the resource_id that represents to what resource it should be related to.


resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

#  ApiGatewayMethod:
#    Type: AWS::ApiGateway::Method
#    Properties:
#      ApiKeyRequired: false
#      AuthorizationType: NONE
#      HttpMethod: POST
#      Integration:
#        ConnectionType: INTERNET
#        Credentials: !GetAtt ApiGatewayIamRole.Arn
#        IntegrationHttpMethod: POST
#        PassthroughBehavior: WHEN_NO_MATCH
#        TimeoutInMillis: 29000
#        Type: AWS_PROXY
#        Uri: !Sub 'arn:aws:apigateway:${AWS::Region}:lambda:path/2015-03-31/functions/${LambdaFunction.Arn}/invocations'
#      OperationName: lambda
#      ResourceId: !Ref ApiGatewayResource
#      RestApiId: !Ref ApiGatewayRestApi


// The integration resource is related to how are we going to react to the request that we just received, it could go from passing the request to a backend, run some lambda function or even doing nothing with it. Besides the arguments previously referenced ( rest_api_id and resource_id ), we have the http_method argument that will be the same as the method resource (that’s why we link both of them with the "${aws_api_gateway_method.method.http_method}" ), the integration_http_method argument represents the HTTP method that will be done from the integration to our backend (again the "ANY" value is a special one) and we have the type argument where we configure what type of integration this is. As for the uri argument it will contain the endpoint to where we are proxying to, and the request_paramenters argument will map what we need from the method resource to our request to the backend, in our case we are are replacing the {proxy} handler present in the uri argument with the path that comes after the domain of our API Gateway.

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://your.domain.com/{proxy}"     # <- I'm just going to go with the AWS URL.
 
  request_parameters =  {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


