resource "aws_cloudformation_stack" "network" {
  name = "Reginald"

  #parameters = {
  #  VPCCidr = "10.0.0.0/16"
  #}

  template_body = <<STACK



AWSTemplateFormatVersion: 2010-09-09
Description: AWS API Gateway with a Lambda Integration

Resources:
  ApiGatewayRestApi:
    Type: AWS::ApiGateway::RestApi
    Properties:
      Name: lambda-api
      ApiKeySourceType: HEADER
      Description: An API Gateway with a Lambda Integration
      EndpointConfiguration:
        Types:
          - REGIONAL
      Policy: >-
        {"Version": "2012-10-17","Statement": [{"Effect": "Allow","Principal":
        "*","Action": "execute-api:Invoke","Resource": ["execute-api:/*"]}]}
      Tags: 
        - {"Key" : "ODINAPPID_ENV_ROLE_STACK", "Value" : "1117_dev_AWS_Toolbox"}

  ApiGatewayResource:
    Type: AWS::ApiGateway::Resource
    Properties:
      ParentId: !GetAtt ApiGatewayRestApi.RootResourceId
      PathPart: lambda                     
      RestApiId: !Ref ApiGatewayRestApi

  ApiGatewayMethod:
    Type: AWS::ApiGateway::Method
    Properties:
      ApiKeyRequired: false
      AuthorizationType: NONE
      HttpMethod: POST
      Integration:
        ConnectionType: INTERNET
        Credentials: !GetAtt ApiGatewayIamRole.Arn
        IntegrationHttpMethod: POST
        PassthroughBehavior: WHEN_NO_MATCH
        TimeoutInMillis: 29000
        Type: AWS_PROXY
        Uri: !Sub 'arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${LambdaFunction.Arn}/invocations'
      OperationName: lambda
      ResourceId: !Ref ApiGatewayResource
      RestApiId: !Ref ApiGatewayRestApi

  ApiGatewayModel:
    Type: AWS::ApiGateway::Model
    Properties:
      ContentType: application/json
      RestApiId: !Ref ApiGatewayRestApi
      Schema: {}

  ApiGatewayStage:
    Type: AWS::ApiGateway::Stage
    Properties:
      DeploymentId: !Ref ApiGatewayDeployment
      Description: Lambda API Stage v0
      RestApiId: !Ref ApiGatewayRestApi
      StageName: v0

  ApiGatewayDeployment:
    Type: AWS::ApiGateway::Deployment
    DependsOn: ApiGatewayMethod
    Properties:
      Description: Lambda API Deployment
      RestApiId: !Ref ApiGatewayRestApi

  ApiGatewayIamRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Sid: ''
            Effect: Allow
            Principal:
              Service:
                - apigateway.amazonaws.com
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: LambdaAccess
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action: 'lambda:*'
                Resource: !GetAtt LambdaFunction.Arn

  LambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      Code:
        S3Bucket: here-nss-rd-common-config-prod
        S3Key: cloudformation-templates/webhook.zip
      Description: AWS Lambda function
      FunctionName: lambda-function
      Handler: index.handler
      MemorySize: 256
      Role: 'arn:aws:iam::853426826842:role/WebhookLambdaReadSecrets'
      Runtime: python3.9
      Timeout: 60

  LambdaIamRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /

STACK
}
