module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"

  namespace   =    "courseapi"
  environment =    "prod"
  stage       =     "dynamodb"
  name        = "authorstf"
  delimiter   = "-"
  attributes  = []
 /*  tags        = var.tags */
}
