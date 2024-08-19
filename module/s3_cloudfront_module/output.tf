output "cloudfront_distribution_url" {
  description = "The URL of the CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket
}