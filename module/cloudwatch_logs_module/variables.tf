variable "CLOUDWATCH_LOG_GROUP_NAME" {
  type = string
}

variable "CLOUDWATCH_LOG_STREAM_NAME" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}