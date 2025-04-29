resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  attribute {
    name = var.course_name
    type = "S"
  }


  attribute {
    name = var.course_duration
    type = "N"
  }

  global_secondary_index {
    name            = var.gsi_names["CourseNameIndex"]
    hash_key        = var.gsi_hash_keys["CourseNameIndex"]
    projection_type = var.gsi_projection_types["CourseNameIndex"]
  }

  global_secondary_index {
    name            = var.gsi_names["CourseDurationIndex"]
    hash_key        = var.gsi_hash_keys["CourseDurationIndex"]
    projection_type = var.gsi_projection_types["CourseDurationIndex"]
  }


  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
