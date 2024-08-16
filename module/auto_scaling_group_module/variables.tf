variable "ami" {
  description = "AMI ID for the EC2 instance"
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group"
  type        = number
}



variable "ec2_key_pair_name" {
  type        = string
  description = "EC2 key pair name (.pem file name) "
}
variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "elb_security_group_id" {
  type        = string
  description = "Security Group that is attached with EC2 instance"
  default     = ""
}

variable "ec2_security_group_id" {
  description = "Security group ID to attach to the EC2"
  type        = string
}

variable "VPC_Subnets_ids" {
  type        = list(string)
  description = "Subnets of VPC"
}

variable "VPC_ID" {
  type        = string
  description = "VPC ID used for loadbalancer ..."
}

variable "ec2_role_permissions" {
  type        = list(string)
  description = "List of permissions to attach to the EC2 role"
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  ]
}

variable "target_group_arn" {
  description = "The ARN of the target group to add to the Auto Scaling group"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}