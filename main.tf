module "get_all_authors" {
  source            = "./modules/lambda"
  lambda_name       = "get_all_authors"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-all-authors"
  lambda_source_dir = "${path.root}/lambda_src/get_all_authors"
}

module "get_all_courses" {
  source            = "./modules/lambda"
  lambda_name       = "get_all_courses"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-all-courses-role"
  lambda_source_dir = "${path.root}/lambda_src/get_all_courses"
}

module "get_course_from_id" {
  source            = "./modules/lambda"
  lambda_name       = "get_course_from_id"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/get-cource-from-id-role"
  lambda_source_dir = "${path.root}/lambda_src/get_course_from_id"
}

module "post_course" {
  source            = "./modules/lambda"
  lambda_name       = "post_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/post-lambda-db-role"
  lambda_source_dir = "${path.root}/lambda_src/post_course"
}

module "update_course" {
  source            = "./modules/lambda"
  lambda_name       = "update_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/update-course-role"
  lambda_source_dir = "${path.root}/lambda_src/update_course"
}

module "delete_course" {
  source            = "./modules/lambda"
  lambda_name       = "delete_course"
  lambda_role_arn   = "arn:aws:iam::182498323031:role/delete-course-role"
  lambda_source_dir = "${path.root}/lambda_src/delete_course"
}

module "courses_table" {
  source        = "./modules/dynamodb_courses"
  table_name    = "coursestf"
  hash_key      = "id"
  hash_key_type = "S"
  environment   = "dev"
  course_name = "course_name"
  course_duration = "course_duration"
  gsi_names           = var.gsi_names      
  gsi_hash_keys       = var.gsi_hash_keys    
  gsi_projection_types = var.gsi_projection_types
}

module "authors_table" {
  source        = "./modules/dynamodb_authors"
  table_name    = "authorstf"
  hash_key      = "id"
  hash_key_type = "S"
  environment   = "dev"
  first_name = "first_name"
  last_name = "last_name"
  gsi_names           = var.gsi_names
  gsi_hash_keys       = var.gsi_hash_keys
  gsi_projection_types = var.gsi_projection_types
}

#Використання інтеграцій (складніший код, треба динаміка і важчий дебаг)
/* module "api_gateway" {
  source = "./modules/api_gateway"

  api_name        = "course-api"
  api_description = "API for courses and authors"
  stage_name      = "dev_v1"

  lambda_integrations = [
    {
      resource   = "/authors"
      method     = "GET"
      lambda_arn = aws_lambda_function.get_all_authors.invoke_arn
    },
    {
      resource   = "/courses"
      method     = "GET"
      lambda_arn = aws_lambda_function.get_all_courses.invoke_arn
    },
    {
      resource   = "/courses"
      method     = "POST"
      lambda_arn = aws_lambda_function.post_course.invoke_arn
    },
    {
      resource   = "/courses/{id}"
      method     = "GET"
      lambda_arn = aws_lambda_function.get_course_by_id.invoke_arn
    },
    {
      resource   = "/courses/{id}"
      method     = "PUT"
      lambda_arn = aws_lambda_function.update_course.invoke_arn
    },
    {
      resource   = "/courses/{id}"
      method     = "DELETE"
      lambda_arn = aws_lambda_function.delete_course.invoke_arn
    },
  ]
} */


#чіткіші шляхи, без інтеграцій (але це статика)
/* module "api_gateway" {
  source = "./modules/api_gateway"

  api_name        = "course-api"
  api_description = "API for courses and authors"
  stage_name      = "dev_v1"

  lambda_arn_authors_get      = aws_lambda_function.get_all_authors.invoke_arn
  lambda_arn_course_get       = aws_lambda_function.get_all_courses.invoke_arn
  lambda_arn_course_post      = aws_lambda_function.post_course.invoke_arn
  lambda_arn_course_get_by_id = aws_lambda_function.get_course_by_id.invoke_arn
  lambda_arn_course_update    = aws_lambda_function.update_course.invoke_arn
  lambda_arn_course_delete    = aws_lambda_function.delete_course.invoke_arn
} */

module "api_gateway" {
  source = "./modules/api_gateway"
  api_name        = "course-api_tf"
  api_description = "API for courses and authors"
  stage_name      = "dev_v1"

  lambda_arn_authors_get      = module.get_all_authors.lambda_arn
  lambda_arn_course_get       = module.get_all_courses.lambda_arn
  lambda_arn_course_post      = module.post_course.lambda_arn
  lambda_arn_course_get_from_id = module.get_course_from_id.lambda_arn
  lambda_arn_course_update    = module.update_course.lambda_arn
  lambda_arn_course_delete    = module.delete_course.lambda_arn
}



module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "easycoursetf"
}

/* module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_name          = module.aws_s3_bucket.easycoursetf.bucket
  s3_website_endpoint  = module.aws_s3_bucket_website_configuration.easycoursetf.website_endpoint
  tags = {
    Environment = "dev"
    Project     = "easycourse"
  }
} */

module "cloudfront" {
  source = "./modules/cloudfront"
  s3_origin_domain_name = module.s3_bucket.website_endpoint
  origin_id = "easycourse-static-origin"
  price_class = "PriceClass_100"
  default_root_object = "index.html"
  tags = {
    Environment = "dev"
    Project     = "easycourse"
  }
}

output "cloudfront_domain" {
  value       = module.cloudfront.domain_name
  description = "Use this as the URL for your site"
}

module "sns_to_slack" {
  source              = "./modules/lambda"
  lambda_name         = "sns_to_slack"
  lambda_role_arn            = aws_iam_role.lambda_role.arn
  lambda_source_dir   = "${path.root}/lambda_src/sns_to_slack"
/*   environment_vars = {
    SLACK_WEBHOOK_URL = var.slack_webhook_url
  } */
}

# IAM Role для Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "sns_to_slack-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy та прив'язка
resource "aws_iam_policy" "lambda_policy" {
  name        = "sns-to-slack-policy"
  description = "Allow Lambda to write logs, put CloudWatch metrics, and be invoked by SNS"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# SNS Topic
resource "aws_sns_topic" "alerts_topic" {
  name = "alerts-topic"
}

# Підписка Email
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Підписка Lambda (Slack)
resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "lambda"
  endpoint  = module.sns_to_slack.lambda_function_arn
}

# Дозвіл SNS викликати Lambda
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_slack.lambda_function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts_topic.arn
}

# CloudWatch Alarm для кастомної метрики
resource "aws_cloudwatch_metric_alarm" "custom_metric_alarm" {
  alarm_name          = "CustomMetricAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MyCustomMetric"
  namespace           = "MyAppMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when custom metric >= 1"

  alarm_actions = [
    aws_sns_topic.alerts_topic.arn
  ]
}