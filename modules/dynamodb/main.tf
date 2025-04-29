resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

/*     attribute {
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
    name = var.course_duration
    type = "N"
  } */

  dynamic "attribute" {
    for_each = var.table_name == "authors" ? compact([
      var.first_name, 
      var.last_name]) : []
    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "attribute" {
    for_each = var.table_name == "courses" ? compact([
      var.course_name, 
      tostring(var.course_duration)]) : []
    content {
      name = attribute.value
      type = attribute.value == var.course_duration ? "N" : "S"
    }
  }

dynamic "global_secondary_index" {
  for_each = var.table_name == "authors" ? {
    "FirstNameIndex" = {
      name            = var.gsi_names["FirstNameIndex"]
      hash_key        = var.gsi_hash_keys["FirstNameIndex"]
      projection_type = var.gsi_projection_types["FirstNameIndex"]
      read_capacity   = var.gsi_read_capacity
      write_capacity  = var.gsi_write_capacity
    },
    "LastNameIndex" = {
      name            = var.gsi_names["LastNameIndex"]
      hash_key        = var.gsi_hash_keys["LastNameIndex"]
      projection_type = var.gsi_projection_types["LastNameIndex"]
      read_capacity   = var.gsi_read_capacity
      write_capacity  = var.gsi_write_capacity
    }
  } : var.table_name == "courses" ? {
    "CourseNameIndex" = {
      name            = var.gsi_names["CourseNameIndex"]
      hash_key        = var.gsi_hash_keys["CourseNameIndex"]
      projection_type = var.gsi_projection_types["CourseNameIndex"]
      read_capacity   = var.gsi_read_capacity
      write_capacity  = var.gsi_write_capacity
    },
    "CourseDurationIndex" = {
      name            = var.gsi_names["CourseDurationIndex"]
      hash_key        = var.gsi_hash_keys["CourseDurationIndex"]
      projection_type = var.gsi_projection_types["CourseDurationIndex"]
      read_capacity   = var.gsi_read_capacity
      write_capacity  = var.gsi_write_capacity
    }
  } : {}

  content {
    name            = each.value.name
    hash_key        = each.value.hash_key
    projection_type = each.value.projection_type
    read_capacity   = each.value.read_capacity
    write_capacity  = each.value.write_capacity
  }
}


  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
