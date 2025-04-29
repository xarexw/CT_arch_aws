resource "aws_lambda_function" "this" {
  function_name = var.lambda_name
  role          = var.lambda_role_arn
  runtime       = "python3.13"
  handler       = "handler.lambda_handler"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout       = 10
  memory_size   = 128
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/build/${var.lambda_name}.zip"
}