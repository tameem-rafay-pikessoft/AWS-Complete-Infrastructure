
# Create SNS topic
resource "aws_sns_topic" "codepipeline_notifications" {
  name = "codepipeline-notifications"
  tags = var.tags
}

# Subscribe email to SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  for_each  = toset(var.notification_email_addresses)
  topic_arn = aws_sns_topic.codepipeline_notifications.arn
  protocol  = "email"
  endpoint  = each.value
}
