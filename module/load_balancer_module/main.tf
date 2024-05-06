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
  tags = var.tags
}

resource "aws_lb" "elastic_load_balancer" {
  name               = var.elb_public_name
  internal           = false         # Set to true for internal ELB
  load_balancer_type = "application" # Specify the load balancer type (e.g., application, network)

  security_groups = [
    aws_security_group.elb_sg.id # Reference the ID of the ELB security group
  ]

  subnets                    = var.VPC_Subnets_ids
  enable_deletion_protection = false # Set to true to prevent accidental deletion
  tags                       = var.tags
}

