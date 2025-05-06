resource "aws_s3_bucket" "easycoursetf" {
  bucket = "easycoursetf"
}

resource "aws_s3_bucket_public_access_block" "easycoursetf" {
  bucket = aws_s3_bucket.easycoursetf.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.easycoursetf.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.easycoursetf.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AddPerm"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.easycoursetf.arn}/*"
      }
    ]
  })
}



