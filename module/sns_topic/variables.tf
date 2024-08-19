variable "notification_email_addresses" {
  description = "List of email addresses to receive notifications for topic events"
  type        = list(string)
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}