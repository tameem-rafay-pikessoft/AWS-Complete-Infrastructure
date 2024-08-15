resource "aws_sns_topic" "alerts_topic" {
  name = "cloudwatch_alerts_topic"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email_subscription" {
  for_each  = toset(var.cloudwatch_alerts_email_addresses)
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = each.value
}

# This code is creating an IAM role that can be assumed by the CloudWatch service and attaching a policy
# to that role which allows full access to CloudWatch Alarms. 
# This would typically be used to allow CloudWatch to perform actions on your behalf, 
# such as publishing notifications to an SNS topic when an alarm is triggered.
resource "aws_iam_role" "cloudwatch" {
  name = "cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudwatch.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_cloudwatch_metric_alarm" "ram_usage_alarm" {
  alarm_name                = "High_RAM_Usage_Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This alarm triggers when RAM usage exceeds 70%."
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  # ok_actions                = [aws_sns_topic.alerts_topic.arn]
  # insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
  tags                      = var.tags
# SELECT AVG(mem_used_percent) FROM CWAgent WHERE AutoScalingGroupName = 'Autoscaling_group'
# SELECT AVG(mem_used_percent) FROM CWAgent GROUP BY AutoScalingGroupName, ImageId, InstanceId, InstanceType


  # Add this block to filter the metrics by an Auto Scaling group
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_usage_alarm" {
  alarm_name                = "High_Disk_Usage_Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This alarm triggers when Disk usage exceeds 70%."
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  # ok_actions                = [aws_sns_topic.alerts_topic.arn]
  # insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
  tags                      = var.tags

  # Add this block to filter the metrics by an Auto Scaling group
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

}

resource "aws_cloudwatch_metric_alarm" "cpu_usage_alarm" {
  alarm_name                = "High_CPU_Usage_Alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This alarm triggers when CPU usage exceeds 70%."
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  # ok_actions                = [aws_sns_topic.alerts_topic.arn]
  # insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
  tags                      = var.tags

  # Add this block to filter the metrics by an Auto Scaling group
  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

}