module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"

  namespace   = "courseapi"
  environment = "prod"
  stage       = "dynamodb"
  name        = "courses"
  delimiter   = "-"
  attributes  = []
/*   tags        = var.tags */
}

/* module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"

  namespace   = var.namespace       # "courseapi"
  environment = var.environment     # "prod"
  stage       = var.stage           # "dynamodb"
  name        = var.table_name      # "courses"
  delimiter   = "-"
  attributes  = []
  tags        = var.tags
} */

