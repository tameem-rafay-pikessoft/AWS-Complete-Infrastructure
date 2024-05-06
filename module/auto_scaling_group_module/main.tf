resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "Autoscaling_group"
  launch_configuration = aws_launch_configuration.alb_launch_configuration.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = var.VPC_Subnets_ids
  target_group_arns = [
    aws_lb_target_group.lb_target_group.arn # Reference the ARN of the target group
  ]
}


resource "aws_lb_target_group" "lb_target_group" {
  name     = "elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID # Update with your VPC ID
  tags     = var.tags
  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_launch_configuration" "alb_launch_configuration" {
  name            = "alb-launch-configuration"
  image_id        = var.ami                     # Update with your AMI ID
  instance_type   = var.instance_type           # Update with your desired instance type
  security_groups = [var.elb_security_group_id] # Reference the ELB security group
  user_data       = file("${path.module}/../../Utils/EC2_user_data.sh")
}
