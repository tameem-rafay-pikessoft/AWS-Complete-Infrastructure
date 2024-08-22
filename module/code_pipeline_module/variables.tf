variable "tags" {
  type    = map(string)
  default = {}
}


variable "AWS_CODE_PIPELINE_NAME" {
  type        = string
  description = "Name of AWS Code pipeline name"
}

variable "S3_BUCKET_FOR_PIPELINE_ARTIFACTS" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
}

variable "FULL_REPOSITORY_ID" {
  type        = string
  description = "Repository used in code pipeline"
}

variable "BRANCH_NAME" {
  type        = string
  description = "Select branch from repository "
}

variable "codePipeline_notification_email_addresses" {
  description = "List of email addresses for code pipeline notifications"
  type        = list(string)
}

variable "CODE_STAR_CONNECTION_ARN" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
}

variable "sns_topic_arn" {
  type        = string
  description = "sns topic arn where to send the pipeline notifications"
}

variable "code_deploy_application_name" {
  type        = string
  description = "application name of code deploy"
}

variable "code_deploy_role_name" {
  type        = string
  description = "role name for code deploy "
}

variable "code_build_role_name" {
  type        = string
  description = "role name for code build "
}

variable "deployment_config" {
  description = "Configuration for deployment"
  type = object({
    deploy_artifacts_bucket_name = optional(string, "")
    deploy_artifacts_bucket_key  = optional(string, "")
    is_deploy_on_s3_bucket       = optional(bool, false)
    autoscaling_group_name       = optional(string, "")
  })
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