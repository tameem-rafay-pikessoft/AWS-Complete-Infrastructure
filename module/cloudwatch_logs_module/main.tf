resource "aws_cloudwatch_log_group" "log_group" {
  name = var.CLOUDWATCH_LOG_GROUP_NAME
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.CLOUDWATCH_LOG_STREAM_NAME
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

