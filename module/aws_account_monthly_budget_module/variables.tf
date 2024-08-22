variable "MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
}

variable "MAX_ACCOUNT_MONTHLY_BUDGET" {
  description = "Maximum monthly budget for the account"
  type        = number
}

variable "tags" {
  type    = map(string)
  default = {}
}
