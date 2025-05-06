/* variable "bucket_name" {
  description = "Ім'я S3 бакета"
  type        = string
}

variable "s3_website_endpoint" {
  description = "Website endpoint бакета (наприклад easycourse-bucket.s3-website.eu-north-1.amazonaws.com)"
  type        = string
}

variable "tags" {
  description = "Додаткові теги"
  type        = map(string)
  default     = {}
} */

variable "s3_origin_domain_name" {
  description = "The S3 static‑website endpoint (e.g. my-bucket.s3‑website.eu-north-1.amazonaws.com)"
  type        = string
}

variable "origin_id" {
  description = "An identifier for the origin; used in cache‑behaviors"
  type        = string
  default     = "s3‑static‑origin"
}

variable "enabled" {
  description = "Whether to enable the distribution"
  type        = bool
  default     = true
}

variable "comment" {
  description = "A comment to describe this distribution"
  type        = string
  default     = null
}

variable "aliases" {
  description = "List of CNAMEs for the distribution (e.g. your custom domain)"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "CloudFront price class (to limit edge locations and costs)"
  type        = string
  default     = "PriceClass_100" # North America & Europe only
}

variable "default_root_object" {
  description = "The object to serve when the root URL (/) is requested"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Tags to apply to the distribution"
  type        = map(string)
  default     = {}
}
