output "bucket_url" {
  value = aws_s3_bucket.easycoursetf.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.easycoursetf.id
}
