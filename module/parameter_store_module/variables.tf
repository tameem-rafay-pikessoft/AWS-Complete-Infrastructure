variable "parameter_store_name" {
  description = "parameter store name"
}

variable "aws_region" {
  description = "aws region where infra is deployed"
}

variable "aws_profile" {
  description = "aws profile that is setup locally"
}

variable "tags" {
  type    = map(string)
  default = {}
}