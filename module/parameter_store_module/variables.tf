variable "PARAMETER_STORE_NAME" {
  description = "parameter store name"
}

variable "AWS_REGION" {
  description = "aws region where infra is deployed"
}

variable "AWS_PROFILE" {
  description = "aws profile that is setup locally"
}

variable "tags" {
  type    = map(string)
  default = {}
}