variable "cloudwatch_log_group_name" {
  type = string
}

variable "cloudwatch_log_stream_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}