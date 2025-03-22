module "s3" {
  count   = 2
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.0"

  bucket = count.index == 0 ? "${local.bucket_name}-public" : "${local.bucket_name}-private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  block_public_acls       = count.index == 0 ? false : true
  block_public_policy     = count.index == 0 ? false : true
  ignore_public_acls      = count.index == 0 ? false : true
  restrict_public_buckets = count.index == 0 ? false : true

  versioning = {
    enabled = false
  }

  cors_rule = count.index == 0 ? jsonencode([
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["*"]
      expose_headers = []
      max_age_seconds = 3000
    }
  ]) : jsonencode([
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      allowed_origins = ["*"]
      expose_headers = []
      max_age_seconds = 3000
    }
  ])

  policy = count.index == 0 ? jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${local.bucket_name}-public/*"
      }
    ]
  }) : null
}

locals {
  bucket_name = format("%s-%s", var.bucket_name, random_string.suffix.result)
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}