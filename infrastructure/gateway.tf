resource "aws_apigatewayv2_api" "api" {
  name                         = "api"
  protocol_type                = "HTTP"
  description                  = "The API for all my things"
  disable_execute_api_endpoint = true
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "api.chatha.dev"
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.api.id
  name   = "$default"
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.default.id
}

resource "aws_apigatewayv2_authorizer" "api-cognito-admin" {
  api_id           = aws_apigatewayv2_api.api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-admin-authorizor"
  jwt_configuration {
    audience = ["6v4lqk1oe7fikr38ht0sk8s0nm"] // Not a secret
    issuer   = "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_StGFbgsoy/"
  }
}

//resource "aws_apigatewayv2_integration" "comments" {
//  api_id               = aws_apigatewayv2_api.api.id
//  integration_type     = "AWS_PROXY"
//  connection_type      = "INTERNET"
//  description          = "Comments API"
//  integration_method   = "POST"
//  integration_uri      = aws_lambda_function.comments.invoke_arn
//  passthrough_behavior = "WHEN_NO_MATCH"
//}

//resource "aws_apigatewayv2_route" "api-personal-comments-POST" {
//  api_id             = aws_apigatewayv2_api.api.id
//  route_key          = "POST /personal/comments"
//  authorization_type = "JWT"
//  authorizer_id      = aws_apigatewayv2_authorizer.api-cognito-admin.id
//  target             = "integrations/${aws_apigatewayv2_integration.comments.id}"
//}
