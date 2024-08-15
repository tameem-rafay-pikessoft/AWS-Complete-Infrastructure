variable "cloudwatch_alerts_email_addresses" {
  description = "List of email addresses to subscribe to the SNS topic"
  type        = list(string)
  default     = [] # Add default email addresses if desired
}

variable "autoscaling_group_name" {
  description = "autoscaling group name"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}