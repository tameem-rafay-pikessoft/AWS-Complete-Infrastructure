variable "AWS_REGION" {
  type        = string
  description = "AWS region where resources will be provisioned"
}

variable "AWS_PROFILE" {
  type        = string
  description = "AWS profile that is setup locally"
}

variable "SSH_ALLOWED_IP" {
  type        = string
  description = "Allowed IP for SSH access"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.SSH_ALLOWED_IP))
    error_message = "The SSH_ALLOWED_IP must be a valid IPv4 address in CIDR notation."
  }
}

variable "PROJECT_NAME" {
  type        = string
  description = "Project name"
}

variable "ENVIRNMENT_NAME" {
  type        = string
  description = "Environment name (e.g., Dev, Stage, Prod)"

  validation {
    condition     = contains(["Dev", "Stage", "Prod"], var.ENVIRNMENT_NAME)
    error_message = "The ENVIRNMENT_NAME must be either Dev, Stage, Prod."
  }
}

variable "AUTO_SCALING_CONFIG" {
  description = "Configuration for autoscaling group"
  type = object({
    ASG_MIN_SIZE         = number
    ASG_MAX_SIZE         = number
    ASG_DESIRED_CAPACITY = number
  })
  default = {
    ASG_MIN_SIZE         = 1
    ASG_MAX_SIZE         = 1
    ASG_DESIRED_CAPACITY = 1
  }
}

variable "EC2_CONFIG" {
  description = "Configuration for EC2 instance"
  type = object({
    EC2_INSTANCE_NAME          = string
    EC2_INSTANCE_TYPE          = string
    EC2_INSTANCE_AMI           = string
    EC2_INSTANCE_PEM_FILE_NAME = string
  })
}

variable "PARAMETER_STORE_NAME" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
}

variable "CLOUDWATCH_LOG_GROUP_NAME" {
  type        = string
  description = "Name of the CloudWatch log group"
}

variable "CLOUDWATCH_LOG_STREAM_NAME" {
  type        = string
  description = "Name of the CloudWatch log stream"
}

variable "DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES" {
  type        = list(string)
  description = "List of email addresses for notifications"

  validation {
    condition     = can([for email in var.DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES : regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email)])
    error_message = "All items in the DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES list must be valid email addresses."
  }
}

variable "BE_PIPELINE_CONFIG" {
  description = "Configuration for AWS CodePipeline"
  type = object({
    FULL_REPOSITORY_ID               = string
    AWS_CODE_PIPELINE_NAME           = string
    BRANCH_NAME                      = string
    S3_BUCKET_FOR_PIPELINE_ARTIFACTS = string
    CODE_STAR_CONNECTION_ARN         = string
    CODE_DEPLOY_APPLICATION_NAME     = string
    CODE_PIPELINE_ROLE_NAME          = string
    CODE_DEPLOY_ROLE_NAME            = string
    CODE_BUILD_ROLE_NAME             = string
    CODE_PIPELINE_POLICY_NAME        = string
    CODE_BUILD_PROJECT_NAME          = string
  })
}
variable "CLOUD_FRONT_WITH_S3_ADMIN_PANEL_CONFIG" {
  description = "Configuration for Cloudfront with S3 deployment"
  type = object({
    S3_BUCKET_NAME = string
    ORIGIN_ID      = string
    PRICE_CLASS    = string
  })
}
variable "ADMIN_PANEL_PIPELINE_CONFIG" {
  description = "Configuration for AWS CodePipeline for FE deployment"
  type = object({
    FULL_REPOSITORY_ID               = string
    AWS_CODE_PIPELINE_NAME           = string
    BRANCH_NAME                      = string
    S3_BUCKET_FOR_PIPELINE_ARTIFACTS = string
    CODE_STAR_CONNECTION_ARN         = string
    DEPLOY_ARTIFACTS_BUCKET_NAME     = string
    DEPLOY_ARTIFACTS_BUCKET_KEY      = string
    CODE_DEPLOY_APPLICATION_NAME     = string
    CODE_PIPELINE_ROLE_NAME          = string
    CODE_DEPLOY_ROLE_NAME            = string
    CODE_BUILD_ROLE_NAME             = string
    CODE_PIPELINE_POLICY_NAME        = string
    CODE_BUILD_PROJECT_NAME          = string
  })
}

variable "DEFAULT_VPC_ID" {
  type        = string
  description = "VPC ID used for Load Balancer"
}

variable "DEFAULT_VPC_SUBNET_ID" {
  type        = list(string)
  description = "Subnets of the VPC"
}

variable "ELB_PUBLIC_NAME" {
  type        = string
  description = "Public name of the ELB"
}

variable "MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES" {
  type        = list(string)
  description = "List of email addresses for budget notifications"

  validation {
    condition     = can([for email in var.MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES : regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email)])
    error_message = "All items in the MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES list must be valid email addresses."
  }
}

variable "MAX_ACCOUNT_MONTHLY_BUDGET" {
  type        = number
  description = "Maximum monthly budget for the account"

  validation {
    condition     = var.MAX_ACCOUNT_MONTHLY_BUDGET >= 1
    error_message = "The MAX_ACCOUNT_MONTHLY_BUDGET must be at least 1."
  }
}

variable "ECR_REPOSITORY_NAME_FOR_BE" {
  type        = string
  description = "ECR Repository Name for storing the Docker images"
}
