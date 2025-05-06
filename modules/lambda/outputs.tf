/* output "get_all_authors_lambda_arn" {
  description = "ARN of the 'get_all_authors' Lambda function"
  value       = module.get_all_authors.aws_lambda_function.this.invoke_arn
}

output "get_all_courses_lambda_arn" {
  description = "ARN of the 'get_all_courses' Lambda function"
  value       = module.get_all_courses.aws_lambda_function.this.invoke_arn
}

output "get_course_from_id_lambda_arn" {
  description = "ARN of the 'get_course_from_id' Lambda function"
  value       = module.get_course_from_id.aws_lambda_function.this.invoke_arn
}

output "post_course_lambda_arn" {
  description = "ARN of the 'post_course' Lambda function"
  value       = module.post_course.aws_lambda_function.this.invoke_arn
}

output "update_course_lambda_arn" {
  description = "ARN of the 'update_course' Lambda function"
  value       = module.update_course.aws_lambda_function.this.invoke_arn
}

output "delete_course_lambda_arn" {
  description = "ARN of the 'delete_course' Lambda function"
  value       = module.delete_course.aws_lambda_function.this.invoke_arn
} */

output "lambda_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_label_id" {
  description = "Generated label-based ID"
  value       = aws_lambda_function.this.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

