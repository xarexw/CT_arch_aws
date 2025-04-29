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
  default = ""
}

variable "last_name" {
  type        = string
  description = "Last name of the author"
  default = ""
}

variable "course_name" {
  type        = string
  description = "Name of the course"
  default = ""
}

variable "duration" {
  type        = number
  description = "Duration of the course in hours"
  default = null
}

