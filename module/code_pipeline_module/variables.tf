variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_name" {
  type        = string
  description = "Instance name that is included in deployment group"
}

variable "AWSCodePipeLineName" {
  type        = string
  description = "Name of AWS Code pipeline name"
}

variable "s3BucketNameForArtifacts" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
}

variable "FullRepositoryId" {
  type        = string
  description = "Repository used in code pipeline"
}

variable "BranchName" {
  type        = string
  description = "Select branch from repository "
}

variable "codePipeline_notification_email_addresses" {
  description = "List of email addresses for code pipeline notifications"
  type        = list(string)
}

variable "CodeStarConnectionArn" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
}