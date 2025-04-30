output "project_name" {
  description = "The name of the project"
  value       = var.project_name
}

output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "environment" {
  description = "The environment used for deployment"
  value       = var.environment
}

output "namespace" {
  description = "The project namespace"
  value       = var.namespace
}

output "stage" {
  description = "The deployment stage"
  value       = var.stage
}

output "get_all_authors_lambda_arn" {
  description = "ARN of the 'get_all_authors' Lambda function"
  value       = module.get_all_authors.lambda_function_arn
}

output "get_all_courses_lambda_arn" {
  description = "ARN of the 'get_all_courses' Lambda function"
  value       = module.get_all_courses.lambda_function_arn
}

output "get_course_from_id_lambda_arn" {
  description = "ARN of the 'get_course_from_id' Lambda function"
  value       = module.get_course_from_id.lambda_function_arn
}

output "post_course_lambda_arn" {
  description = "ARN of the 'post_course' Lambda function"
  value       = module.post_course.lambda_function_arn
}

output "update_course_lambda_arn" {
  description = "ARN of the 'update_course' Lambda function"
  value       = module.update_course.lambda_function_arn
}

output "delete_course_lambda_arn" {
  description = "ARN of the 'delete_course' Lambda function"
  value       = module.delete_course.lambda_function_arn
}
