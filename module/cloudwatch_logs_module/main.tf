resource "aws_cloudwatch_log_group" "log_group" {
  name = var.cloudwatch_log_group_name
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.cloudwatch_log_stream_name
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

