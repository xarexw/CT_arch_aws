module "label" {
  source   = "cloudposse/label/null"
  version = "0.25.0"

  namespace  = "arch"
  stage      = "dev"
  name       = var.lambda_name
  attributes = ["lambda"]
  delimiter  = "-"

  tags = {
    Project = "courses-api"
  }
}