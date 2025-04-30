/* output "get_all_authors_lambda_arn" {
  description = "ARN of the 'get_all_authors' Lambda function"
  value       = module.get_all_authors.aws_lambda_function.this.arn
}

output "get_all_courses_lambda_arn" {
  description = "ARN of the 'get_all_courses' Lambda function"
  value       = module.get_all_courses.aws_lambda_function.this.arn
}

output "get_course_from_id_lambda_arn" {
  description = "ARN of the 'get_course_from_id' Lambda function"
  value       = module.get_course_from_id.aws_lambda_function.this.arn
}

output "post_course_lambda_arn" {
  description = "ARN of the 'post_course' Lambda function"
  value       = module.post_course.aws_lambda_function.this.arn
}

output "update_course_lambda_arn" {
  description = "ARN of the 'update_course' Lambda function"
  value       = module.update_course.aws_lambda_function.this.arn
}

output "delete_course_lambda_arn" {
  description = "ARN of the 'delete_course' Lambda function"
  value       = module.delete_course.aws_lambda_function.this.arn
} */

output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value = aws_lambda_function.this.arn
}

output "lambda_label_id" {
  description = "Generated label-based ID"
  value       = aws_lambda_function.this.arn  
}

