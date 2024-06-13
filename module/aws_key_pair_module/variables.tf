
variable "ec2_instance_pem_file_name" {
  description = ".pem file name is required"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
