resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  attribute {
    name = var.first_name
    type = "S"
  }

  attribute {
    name = var.last_name
    type = "S"
  }

  global_secondary_index {
    name            = var.gsi_names["FirstNameIndex"]
    hash_key        = var.gsi_hash_keys["FirstNameIndex"]
    projection_type = var.gsi_projection_types["FirstNameIndex"]
    read_capacity   = var.gsi_read_capacity
    write_capacity  = var.gsi_write_capacity
  }

  global_secondary_index {
    name            = var.gsi_names["LastNameIndex"]
    hash_key        = var.gsi_hash_keys["LastNameIndex"]
    projection_type = var.gsi_projection_types["LastNameIndex"]
    read_capacity   = var.gsi_read_capacity
    write_capacity  = var.gsi_write_capacity
  }


  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
