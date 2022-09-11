#CREATE S3
resource "aws_s3_bucket" "bucket-cp02" {
  bucket = "bucket-cp02"
}

#S3 POLICY
resource "aws_s3_bucket_policy" "s3-policy" {
  bucket = aws_s3_bucket.bucket-cp02.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect     = "Allow",
        Principal  = "*",
        Action    = "s3:GetObject",
        Resource = "arn:aws:s3:::bucket-cp02/*",
      }
    ]
	})
}

#S3 STATIC WEBSITE
resource "aws_s3_bucket_website_configuration" "bucket-cp02" {
  bucket = aws_s3_bucket.bucket-cp02.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

#S3 OBJECTS
resource "aws_s3_bucket_object" "s3-object" {
    bucket   = aws_s3_bucket.bucket-cp02.id
    for_each = fileset("data/", "*")
    key      = each.value
    source   = "data/${each.value}"
    content_type = "text/html"
}