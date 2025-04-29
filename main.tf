/* resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
} */

module "get_all_authors" {
  source            = "./modules/lambda"
  lambda_name       = "get_all_authors"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-all-authors"
  lambda_source_dir = "${path.root}/lambda_src/get_all_authors"
}

module "get_all_courses" {
  source            = "./modules/lambda"
  lambda_name       = "get_all_courses"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-all-courses-role"
  lambda_source_dir = "${path.root}/lambda_src/get_all_courses"
}

module "get_course_from_id" {
  source            = "./modules/lambda"
  lambda_name       = "get_course_from_id"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-cource-from-id-role"
  lambda_source_dir = "${path.root}/lambda_src/get_course_from_id"
}

module "post_course" {
  source            = "./modules/lambda"
  lambda_name       = "post_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/post-lambda-db-role"
  lambda_source_dir = "${path.root}/lambda_src/post_course"
}

module "update_course" {
  source            = "./modules/lambda"
  lambda_name       = "update_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/update-course-role"
  lambda_source_dir = "${path.root}/lambda_src/update_course"
}

module "delete_course" {
  source            = "./modules/lambda"
  lambda_name       = "delete_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/delete-course-role"
  lambda_source_dir = "${path.root}/lambda_src/delete_course"
}

module "courses_table" {
  source        = "./modules/dynamodb_courses"
  table_name    = "courses"
  hash_key      = "id"
  hash_key_type = "S"
  environment   = "dev"
  course_name = "course_name"
  course_duration = "course_duration"
  gsi_names           = var.gsi_names      
  gsi_hash_keys       = var.gsi_hash_keys    
  gsi_projection_types = var.gsi_projection_types
}

module "authors_table" {
  source        = "./modules/dynamodb_authors"
  table_name    = "authors"
  hash_key      = "id"
  hash_key_type = "S"
  environment   = "dev"
  first_name = "first_name"
  last_name = "last_name"
  gsi_names           = var.gsi_names
  gsi_hash_keys       = var.gsi_hash_keys
  gsi_projection_types = var.gsi_projection_types
}
