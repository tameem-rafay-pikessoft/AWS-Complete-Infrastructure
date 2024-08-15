resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "Autoscaling_group"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.VPC_Subnets_ids
  target_group_arns = [
    aws_lb_target_group.lb_target_group.arn # Reference the ARN of the target group
  ]
}



resource "aws_lb_target_group" "lb_target_group" {
  name     = "elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID
  tags     = var.tags
  health_check {
    enabled             = true  # Enable health checks
    path                = "/"   # The destination for the health check request
    protocol            = "HTTP"  # The protocol to use for the health check
    port                = "traffic-port"  # The port to use for the health check
    interval            = 300  # The time between health checks in seconds
    timeout             = 50  # The amount of time to wait when receiving a response from the health check
    healthy_threshold   = 3  # The number of consecutive successful health checks required before considering an unhealthy target healthy
    unhealthy_threshold = 2  # The number of consecutive failed health checks required before considering a target unhealthy
  }
}

resource "aws_launch_template" "launch_template" {
  name          = "asg_launch_template"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.ec2_key_pair_name

  user_data = base64encode(file("${path.module}/../../Utils/EC2_user_data.sh"))

  network_interfaces {
    security_groups = compact([var.elb_security_group_id != null ? var.elb_security_group_id : "", var.ec2_security_group_id])
  }
}