resource "aws_api_gateway_rest_api" "course_api" {
  name        = "course-api"
  description = "API for courses and authors"
}

# /authors
resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  path_part   = "authors"
}

# /course
resource "aws_api_gateway_resource" "course" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  path_part   = "course"
}

# /course/{course-id}
resource "aws_api_gateway_resource" "course_id" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "{course-id}"
}

resource "aws_api_gateway_request_validator" "body_validator" {
  rest_api_id            = aws_api_gateway_rest_api.course_api.id
  name                   = "validate-body"
  validate_request_body  = true
  validate_request_parameters = false
}

# GET /authors
resource "aws_api_gateway_method" "authors_get" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authors_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.authors_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.authors_get.invoke_arn
}

# GET /course
resource "aws_api_gateway_method" "course_get" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.course_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_get.invoke_arn
}

# POST /course
resource "aws_api_gateway_method" "course_post" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "POST"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.body_validator.id
}

resource "aws_api_gateway_integration" "course_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.course_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_post.invoke_arn
}

# GET /course/{course-id}
resource "aws_api_gateway_method" "course_get_from_id" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_get_from_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_get_from_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_get_from_id.invoke_arn
}

# PUT /course/{course-id}
resource "aws_api_gateway_method" "course_update" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "PUT"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.body_validator.id
}

resource "aws_api_gateway_integration" "course_update_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_update.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_update.invoke_arn
}

# DELETE /course/{course-id}
resource "aws_api_gateway_method" "course_delete" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.body_validator.id
}

resource "aws_api_gateway_integration" "course_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.course_delete.invoke_arn
}

locals {
lambda_functions = {
    authors_get      = aws_lambda_function.authors_get.function_name
    course_get       = aws_lambda_function.course_get.function_name
    course_post      = aws_lambda_function.course_post.function_name
    course_id_get    = aws_lambda_function.course_get_from_id.function_name
    course_id_put    = aws_lambda_function.course_update.function_name
    course_id_delete = aws_lambda_function.course_delete.function_name
}
}

resource "aws_lambda_permission" "api_invoke" {
  for_each = local.lambda_functions
  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.course_api.execution_arn}/*/*"
}

# DEPLOY / STAGE
resource "aws_api_gateway_deployment" "course_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.authors_get_integration,
    aws_api_gateway_integration.course_get_integration,
    aws_api_gateway_integration.course_post_integration,
    aws_api_gateway_integration.course_get_from_id_integration,
    aws_api_gateway_integration.course_update_integration,
    aws_api_gateway_integration.course_id_delete_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  description = "Deployment for course API"
}

resource "aws_api_gateway_stage" "course_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  deployment_id = aws_api_gateway_deployment.course_api_deployment.id
  stage_name    = "dev_v1"
}


# OPTIONS /authors
resource "aws_api_gateway_method" "authors_options" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authors_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "authors_options_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "authors_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  status_code = aws_api_gateway_method_response.authors_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
  }
}

# OPTIONS /course
resource "aws_api_gateway_method" "course_options" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.course_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "course_options_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.course_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "course_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.course_options.http_method
  status_code = aws_api_gateway_method_response.course_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
  }
}

# OPTIONS /course/{course-id}
resource "aws_api_gateway_method" "course_id_options" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_id_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.course_id_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "course_id_options_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.course_id_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "course_id_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  resource_id = aws_api_gateway_resource.course_id.id
  http_method = aws_api_gateway_method.course_id_options.http_method
  status_code = aws_api_gateway_method_response.course_id_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
  }
}
