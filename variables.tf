variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "AWS_CT_Platform"
}

variable "environment" {
  description = "The environment for the project (e.g., univercity, production)"
  type        = string
}

variable "namespace" {
  description = "The namespace for the project (e.g., 2025)"
  type        = string
}

variable "stage" {
  description = "The stage of the deployment (e.g., dev, prod)"
  type        = string
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

variable "alert_email" {
  description = "Email to receive SNS notifications"
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack Incoming Webhook URL"
  type        = string
}
