output "project_name" {
  description = "The name of the project"
  value       = var.project_name
}

output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "environment" {
  description = "The environment used for deployment"
  value       = var.environment
}

output "namespace" {
  description = "The project namespace"
  value       = var.namespace
}

output "stage" {
  description = "The deployment stage"
  value       = var.stage
}