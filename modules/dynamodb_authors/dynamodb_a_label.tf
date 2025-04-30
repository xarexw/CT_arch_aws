module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"

  namespace   =    "courseapi"
  environment =    "prod"
  stage       =     "dynamodb"
  name        = "courses"
  delimiter   = "-"
  attributes  = []
 /*  tags        = var.tags */
}
