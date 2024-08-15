variable "ecr_repository_name" {
  type        = string
  description = "ECR Repository Name for storing the docker images" 
}


variable "tags" {
  type    = map(string)
  default = {}
}