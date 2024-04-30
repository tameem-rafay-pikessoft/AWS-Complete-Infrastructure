variable "ami" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
}
variable "VPC_Subnets_ids" {
  type        = list(string)
  description = "Subnets of VPC"
}

variable "tags" {
  type    = map(string)
  default = {}
}