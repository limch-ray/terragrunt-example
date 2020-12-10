terraform {
  required_version = ">= 0.14.0"
}

resource "aws_api_gateway_rest_api" "test_api" {
  name        = "test_api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "test_api_resource_v1" {
  depends_on = [aws_api_gateway_rest_api.test_api]

  rest_api_id = aws_api_gateway_rest_api.test_api.id
  parent_id   = aws_api_gateway_rest_api.test_api.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "test_api_resource_send" {
  depends_on = [aws_api_gateway_rest_api.test_api]

  rest_api_id = aws_api_gateway_rest_api.test_api.id
  parent_id   = aws_api_gateway_resource.test_api_resource_v1.id
  path_part   = "send"
}

resource "aws_api_gateway_method" "test_api_method" {
  depends_on = [aws_api_gateway_resource.test_api_resource_send]

  rest_api_id   = aws_api_gateway_rest_api.test_api.id
  resource_id   = aws_api_gateway_resource.test_api_resource_send.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "test_api_integration" {
  depends_on = [aws_api_gateway_method.test_api_method]

  rest_api_id          = aws_api_gateway_rest_api.test_api.id
  resource_id          = aws_api_gateway_resource.test_api_resource_send.id
  http_method          =  aws_api_gateway_method.test_api_method.http_method
  type                 = "AWS"
  integration_http_method = aws_api_gateway_method.test_api_method.http_method
  ### add account id and queue name here ###
  uri = "arn:aws:apigateway:ap-southeast-1:sqs:path/${data.aws_caller_identity.current.account_id}/${var.project_name}-${var.environment}-se_gateway_bundle"
  credentials = aws_iam_role.test_role.arn
  passthrough_behavior = "NEVER"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  depends_on = [aws_api_gateway_integration.test_api_integration]

  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_api_resource_send.id
  http_method = aws_api_gateway_method.test_api_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  depends_on = [aws_api_gateway_method.test_api_method]

  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_api_resource_send.id
  http_method = aws_api_gateway_method.test_api_method.http_method
  status_code = 200
  response_models = { 
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "MyDemoDeployment" {
  depends_on = [aws_api_gateway_integration.test_api_integration]

  rest_api_id = aws_api_gateway_rest_api.test_api.id
  stage_name  = "development"

  lifecycle {
    create_before_destroy = true
  }
}
