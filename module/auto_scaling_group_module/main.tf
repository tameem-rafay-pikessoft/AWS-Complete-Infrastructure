resource "aws_autoscaling_group" "ec2_asg" {
  name = "Autoscaling_group"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  min_size            = var.ASG_MIN_SIZE
  max_size            = var.ASG_MAX_SIZE
  desired_capacity    = var.ASG_DESIRED_CAPACITY
  vpc_zone_identifier = var.DEFAULT_VPC_SUBNET_ID
  target_group_arns   = var.target_group_arn != null ? [var.target_group_arn] : []

}






# Create the role for EC2 instance
resource "aws_iam_role" "EC2_Service_Role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com",
      },
    }],
  })
  tags = var.tags
}

# Attach different policies with EC2 role
resource "aws_iam_role_policy_attachment" "ec2_role_permissions" {
  count      = length(var.ec2_role_permissions)
  policy_arn = var.ec2_role_permissions[count.index]
  role       = aws_iam_role.EC2_Service_Role.name
}

resource "aws_iam_instance_profile" "EC2_instance_profile" {
  name = aws_iam_role.EC2_Service_Role.name
  role = aws_iam_role.EC2_Service_Role.id
  tags = var.tags
}



resource "aws_launch_template" "launch_template" {
  name          = "asg_launch_template"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.ec2_key_pair_name
  iam_instance_profile {
    name = aws_iam_instance_profile.EC2_instance_profile.name
  }

  user_data = base64encode(file("${path.module}/../../Utils/EC2_user_data.sh"))

  network_interfaces {
    security_groups = compact([var.elb_security_group_id, var.ec2_security_group_id])
  }
}