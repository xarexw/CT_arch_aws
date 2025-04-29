variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for the Lambda"
  type        = string
}

variable "lambda_source_dir" {
  description = "Source directory for Lambda code"
  type        = string
}
