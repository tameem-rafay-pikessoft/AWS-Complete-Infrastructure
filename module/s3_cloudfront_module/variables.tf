
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "The origin ID for the CloudFront distribution"
  type        = string
}

variable "price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_200"
}


variable "tags" {
  type    = map(string)
  default = {}
}