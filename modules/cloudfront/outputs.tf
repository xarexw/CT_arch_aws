/* output "cloudfront_domain_name" {
  description = "Домен CloudFront"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID дистрибуції"
  value       = aws_cloudfront_distribution.this.id
} */

output "domain_name" {
  description = "The CloudFront domain name (e.g. d1234abcd.cloudfront.net)"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}
