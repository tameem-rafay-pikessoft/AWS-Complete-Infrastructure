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
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.SSH_ALLOWED_IP))
    error_message = "The SSH_ALLOWED_IP must be a valid IPv4 address."
  }
}

variable "PROJECT_NAME" {
  type        = string
  description = "Project name"
}

variable "ENVIRNMENT_NAME" {
  type        = string
  description = "Environment name (e.g., Development, Staging, Production)"

  validation {
    condition     = contains(["Development", "Staging", "Production"], var.ENVIRNMENT_NAME)
    error_message = "The ENVIRNMENT_NAME must be either 'Development', 'Staging', or 'Production'."
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

variable "EC2_INSTANCE_NAME" {
  type        = string
  description = "Name of the AWS EC2 instance"
}

variable "EC2_INSTANCE_TYPE" {
  type        = string
  description = "EC2 instance type"
}

variable "EC2_INSTANCE_AMI" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "EC2_INSTANCE_PEM_FILE_NAME" {
  type        = string
  description = "Name of the .pem file for EC2 instance"
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

variable "FULL_REPOSITORY_ID" {
  type        = string
  description = "Repository ID used in CodePipeline"
}

variable "AWS_CODE_PIPELINE_NAME" {
  type        = string
  description = "Name of the AWS CodePipeline"
}

variable "BRANCH_NAME" {
  type        = string
  description = "Branch name from the repository"
}

variable "S3_BUCKET_FOR_PIPELINE_ARTIFACTS" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.S3_BUCKET_FOR_PIPELINE_ARTIFACTS))
    error_message = "Bucket name can only contain lowercase letters, numbers, hyphens, and periods."
  }
}

variable "CODE_STAR_CONNECTION_ARN" {
  type        = string
  description = "ARN of the existing connection in CodeStar"
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
