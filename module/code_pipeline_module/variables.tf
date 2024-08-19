variable "tags" {
  type    = map(string)
  default = {}
}

variable "autoscaling_group_name" {
  type        = string
  description = "autoscaling_group_name that is included in deployment group"
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

variable "sns_topic_arn" {
  type        = string
  description = "sns topic arn where to send the pipeline notifications"
}

variable "PipelineVariables" {
  description = "Environment variables for the CodeBuild project"
  type        = map(string)
  default     = {}
}



variable "CodeBuildPolicies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    # "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ]
}