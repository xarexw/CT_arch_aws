output "bucket_url" {
  value = aws_s3_bucket.easycoursetf.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.easycoursetf.id
}

output "website_endpoint" {
  description = "The website endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}
