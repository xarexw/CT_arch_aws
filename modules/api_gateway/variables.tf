variable "api_name" {
  description = "The name of the REST API"
  type        = string
}

variable "lambda_integrations" {
  description = "List of lambda integrations with path and method"
  type = list(object({
    lambda_arn = string
    resource   = string
    method     = string
  }))
}

variable "allowed_methods" {
  default = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}
