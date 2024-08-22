resource "aws_security_group" "elb_sg" {
  name        = "elb-security-group"
  description = "Security group for the ELB"

  # Define ingress rules for your ELB security group
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from all IP addresses
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to all IP addresses
  }

  tags = var.tags
}

resource "aws_lb" "elastic_load_balancer" {
  name               = var.ELB_PUBLIC_NAME
  internal           = false         # Set to true for internal ELB
  load_balancer_type = "application" # Specify the load balancer type (e.g., application, network)

  security_groups = [
    aws_security_group.elb_sg.id # Reference the ID of the ELB security group
  ]

  subnets                    = var.DEFAULT_VPC_SUBNET_ID
  enable_deletion_protection = false # Set to true to prevent accidental deletion
  tags                       = var.tags
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.DEFAULT_VPC_ID
  tags     = var.tags
  health_check {
    enabled             = true           # Enable health checks
    path                = "/"            # The destination for the health check request
    protocol            = "HTTP"         # The protocol to use for the health check
    port                = "traffic-port" # The port to use for the health check
    interval            = 30             # The time between health checks in seconds
    timeout             = 20             # The amount of time to wait when receiving a response from the health check
    healthy_threshold   = 2              # The number of consecutive successful health checks required before considering an unhealthy target healthy
    unhealthy_threshold = 2              # The number of consecutive failed health checks required before considering a target unhealthy
  }
}

resource "aws_lb_listener" "backend_lb" {
  load_balancer_arn = aws_lb.elastic_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

