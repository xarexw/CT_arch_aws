output "bucket_url" {
  value = aws_s3_bucket.easycourse.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}
