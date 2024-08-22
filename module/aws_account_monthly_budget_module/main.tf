# SNS topic
resource "aws_sns_topic" "budget_notification_topic" {
  name = "budget_notification_topic"
  tags = var.tags
}

# SNS subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES)
  topic_arn = aws_sns_topic.budget_notification_topic.arn
  protocol  = "email"
  endpoint  = var.MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES[count.index]
}

resource "aws_budgets_budget" "budget_notification" {
  name         = "month_budget_notification"
  limit_amount = var.MAX_ACCOUNT_MONTHLY_BUDGET
  limit_unit   = "USD"
  budget_type  = "COST"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.MAX_ACCOUNT_MONTHLY_BUDGET
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_notification_topic.arn]
  }
}
