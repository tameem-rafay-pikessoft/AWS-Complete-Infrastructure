variable "ami" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "elb_security_group_id" {
  type        = string
  description = "Security Group that is attached with EC2 instance"
}

variable "VPC_Subnets_ids" {
  type        = list(string)
  description = "Subnets of VPC"
}

variable "VPC_ID" {
  type        = string
  description = "VPC ID used for loadbalancer ..."
}

variable "tags" {
  type    = map(string)
  default = {}
}