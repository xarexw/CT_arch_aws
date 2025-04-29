variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "The partition key name"
}

variable "hash_key_type" {
  type        = string
  description = "The partition key type: S (string), N (number), or B (binary)"
}
variable "environment" {
  type        = string
  default     = "dev"
}

variable "first_name" {
  type        = string
  description = "First name of the author"
  default = null
}

variable "last_name" {
  type        = string
  description = "Last name of the author"
  default = null
}

variable "course_name" {
  type        = string
  description = "Name of the course"
  default = null
}

variable "course_duration" {
  type        = string
  description = "Duration of the course in hours"
  default = null
}

variable "gsi_names" {
  description = "Map of GSI names"
  type        = map(string)
}

variable "gsi_hash_keys" {
  description = "Map of hash keys for GSI"
  type        = map(string)
}

variable "gsi_projection_types" {
  description = "Map of projection types for GSI"
  type        = map(string)
}
