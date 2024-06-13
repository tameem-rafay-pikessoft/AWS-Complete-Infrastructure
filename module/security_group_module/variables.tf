variable "ssh_allowed_ip" {
  type        = string
  description = "IP address allowed for SSH (e.g., '1.2.3.4/32')"
  validation {
    condition     = var.ssh_allowed_ip != "0.0.0.0/0"
    error_message = "SSH port must be specified and cannot be 0"
  }
}

variable "security_group_allowed_ports" {
  type        = list(number)
  description = "List of ports to allow in the security group"
  default     = [80, 443]
}


variable "tags" {
  type    = map(string)
  default = {}
}