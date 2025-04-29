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
    name = var.first_name
    type = "S"
  }

  attribute {
    name = var.last_name
    type = "S"
  }

  attribute {
    name = var.duration
    type = "N"
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
