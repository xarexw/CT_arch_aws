variable "api_name" {
  type = string
}
variable "api_description" {
  type    = string
  default = ""
}
variable "stage_name" {
  type    = string
  default = "dev_v1"
}
/* variable "lambda_integrations" {
  description = "List of { lambda_arn, resource, method } for each endpoint"
  type = list(object({
    lambda_arn = string
    resource   = string
    method     = string
  }))
} */

variable "lambda_arn_authors_get" {
  type = string
}

variable "lambda_arn_course_get" {
  type = string
}

variable "lambda_arn_course_post" {
  type = string
}

variable "lambda_arn_course_get_from_id" {
  type = string
}

variable "lambda_arn_course_update" {
  type = string
}

variable "lambda_arn_course_delete" {
  type = string
}

