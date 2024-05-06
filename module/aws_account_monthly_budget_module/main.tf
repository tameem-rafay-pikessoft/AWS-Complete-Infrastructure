# SNS topic
resource "aws_sns_topic" "budget_notification_topic" {
  name = "budget_notification_topic"
  tags = var.tags
}

# SNS subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.monthly_budget_notification_email_addresses)
  topic_arn = aws_sns_topic.budget_notification_topic.arn
  protocol  = "email"
  endpoint  = var.monthly_budget_notification_email_addresses[count.index]
}

resource "aws_budgets_budget" "budget_notification" {
  name              = "month_budget_notification"
  limit_amount      = var.max_account_monthly_budget
  limit_unit        = "USD"
  budget_type       = "COST"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = var.max_account_monthly_budget
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.monthly_budget_notification_email_addresses
    subscriber_sns_topic_arns = [aws_sns_topic.budget_notification_topic.arn]
  }
}
