# === API ===
resource "aws_api_gateway_rest_api" "course_api" {
  name        = var.api_name
  description = var.api_description
}

# === RESOURCES ===
resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "course" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_rest_api.course_api.root_resource_id
  path_part   = "course"
}

resource "aws_api_gateway_resource" "course_id" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "{course-id}"
}

# === METHODS + INTEGRATIONS ===

# GET /authors
resource "aws_api_gateway_method" "authors_get" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authors_get" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.authors_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_authors_get
}

# GET /course
resource "aws_api_gateway_method" "course_get" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_get" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.course_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_course_get
}

# POST /course
resource "aws_api_gateway_method" "course_post" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "POST"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.body_validator.id
}

resource "aws_api_gateway_integration" "course_post" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.course_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_course_post
}

# GET /course/{course-id}
resource "aws_api_gateway_method" "course_get_from_id" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_get_from_id" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_get_from_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_course_get_from_id
}

# PUT /course/{course-id}
resource "aws_api_gateway_method" "course_update" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "PUT"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.body_validator.id
}

resource "aws_api_gateway_integration" "course_update" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_update.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_course_update
}

# DELETE /course/{course-id}
resource "aws_api_gateway_method" "course_delete" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  resource_id   = aws_api_gateway_resource.course_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "course_delete" {
  rest_api_id             = aws_api_gateway_rest_api.course_api.id
  resource_id             = aws_api_gateway_resource.course_id.id
  http_method             = aws_api_gateway_method.course_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn_course_delete
}

# DEPLOYMENT + STAGE
resource "aws_api_gateway_deployment" "course_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.authors_get,
    aws_api_gateway_integration.course_get,
    aws_api_gateway_integration.course_post,
    aws_api_gateway_integration.course_get_from_id,
    aws_api_gateway_integration.course_update,
    aws_api_gateway_integration.course_delete,
  ]
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  description = "Deployment for course API"
}

resource "aws_api_gateway_stage" "course_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.course_api.id
  deployment_id = aws_api_gateway_deployment.course_api_deployment.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_request_validator" "body_validator" {
  rest_api_id = aws_api_gateway_rest_api.course_api.id
  name        = "BodyValidator"
  validate_request_body = true
  validate_request_parameters = false
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
