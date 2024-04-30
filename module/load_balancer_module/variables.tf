variable "elb_public_name" {
  type        = string
  description = "Public name of ELB"
    validation {
      condition     = can(regex("^([a-zA-Z0-9-]+)$", var.elb_public_name))
      error_message = "Invalid ELB public name. Only alphanumeric characters and hyphens are allowed."
    }
}
  

variable "VPC_ID" {
  type        = string
  description = "VPC ID used for loadbalancer ..."
}

variable "VPC_Subnets_ids" {
  type        = list(string)
  description = "Subnets of VPC"
}

variable "tags" {
  type    = map(string)
  default = {}
}