# s3_cloudfront_module/main.tf

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = var.tags
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 bucket distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # https://aws.amazon.com/cloudfront/pricing/
  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  tags = var.tags
}

# An Origin Access Identity is a special CloudFront user that you can associate with your distribution to allow 
# CloudFront to access your files in your S3 bucket, while restricting access to S3 directly (i.e., requests that don’t come through CloudFront).
# This is a security feature that prevents someone from bypassing CloudFront and accessing the S3 files directly.

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.bucket_name} bucket"
}