resource "aws_autoscaling_group" "example_asg" {
  name                 = "Autoscaling_group"
  launch_configuration = aws_launch_configuration.example_lc.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = var.VPC_Subnets_ids
  target_group_arns = [
    aws_lb_target_group.example_target_group.arn  # Reference the ARN of the target group
  ]
}

resource "aws_launch_configuration" "alb_launch_configuration" {
  name          = "alb-launch-configuration"
  image_id      = var.ami # Update with your AMI ID
  instance_type = var.instance_type  # Update with your desired instance type
  security_groups = [aws_security_group.elb_sg.id]  # Reference the ELB security group
  user_data     = <<-EOF
                    # Paste your user data script here (if needed)
                    EOF
}
