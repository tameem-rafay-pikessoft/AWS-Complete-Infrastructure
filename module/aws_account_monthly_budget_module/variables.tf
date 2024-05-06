variable "monthly_budget_notification_email_addresses" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
}

variable "max_account_monthly_budget" {
  description = "Maximum monthly budget for the account"
  type        = number
}

variable "tags" {
  type    = map(string)
  default = {}
}
