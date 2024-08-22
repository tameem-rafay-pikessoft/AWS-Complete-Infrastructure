variable "AWS_REGION" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}
variable "AWS_PROFILE" {
  type        = string
  description = "AWS profile that is setup locally"
  default     = "test-aws-terraform-Infrastructure" # Replace with your desired default region
}

# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------


variable "SSH_ALLOWED_IP" {
  type    = string
  default = "39.44.28.92/32"
}



# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------



variable "PROJECT_NAME" {
  type    = string
  default = "test-aws-terraform-Infrastructure"
}

variable "ENVIRNMENT_NAME" {
  type    = string
  default = "Development"
}

# ----------------------------------------------------------------
# -------------------------- Auto Scaling Group ------------------
# ----------------------------------------------------------------

variable "ASG_MIN_SIZE" {
  description = "Minimum size of the Auto Scaling group"
  type        = number
  default     = 1
}

variable "ASG_MAX_SIZE" {
  description = "Maximum size of the Auto Scaling group"
  type        = number
  default     = 1
}

# NOTE: ASG_DESIRED_CAPACITY can not be less then min capacity
variable "ASG_DESIRED_CAPACITY" {
  description = "Desired number of instances in the Auto Scaling group"
  type        = number
  default     = 1
}

# ----------------------------------------------------------------
# --------------- EC2 VARIABLES ------------------
# ----------------------------------------------------------------

variable "EC2_INSTANCE_NAME" {
  type        = string
  description = "Name of the AWS EC2 instance name"
  default     = "Test-Project-development"
}

variable "EC2_INSTANCE_TYPE" {
  type        = string
  description = "EC2 instance type e.g. micro, nano, large ... "
  default     = "t2.micro"
}
variable "EC2_INSTANCE_AMI" {
  type        = string
  description = "Name of the AWS EC2 instance name"
  default     = "ami-0a3c3a20c09d6f377"
}

variable "EC2_INSTANCE_PEM_FILE_NAME" {
  type        = string
  description = "name of .pem file for EC2 instance"
  default     = "Test-Project-development"
}

# ----------------------------------------------------------------
# --------------- AWS PARAMETER STORE VARIABLES ------------------
# ----------------------------------------------------------------

variable "PARAMETER_STORE_NAME" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
  default     = "/be/env"
}

# ----------------------------------------------------------------
# --------------- Cloudwatch VARIABLES ------------------
# ----------------------------------------------------------------

variable "CLOUDWATCH_LOG_GROUP_NAME" {
  type        = string
  description = "Name of the cloudwatch log group"
  default     = "/Test-Project-development/log-group"
}

variable "CLOUDWATCH_LOG_STREAM_NAME" {
  type        = string
  description = "Name of the cloudwatch log stream"
  default     = "Test-Project-development-log-stream"
}

# ----------------------------------------------------------------
# --------------- AWS CodePipeline VARIABLES ---------------------
# ----------------------------------------------------------------

variable "DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES" {
  description = "List of email addresses for notifications"
  type        = list(string)
  default     = ["tameem.rafay@pikessoft.com"]
}

variable "FULL_REPOSITORY_ID" {
  type        = string
  description = "Repository used in code pipeline"
  default     = "rafay-tariq/equipx-test-demo"
}

variable "AWS_CODE_PIPELINE_NAME" {
  type        = string
  description = "Name of AWS code pipeline name"
  default     = "equipX-development-BE"
}

variable "BRANCH_NAME" {
  type        = string
  description = "Select branch from repository "
  default     = "master"
}

variable "S3_BUCKET_FOR_PIPELINE_ARTIFACTS" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
  default     = "development-test-project-codepipeline-artifacts"
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.S3_BUCKET_FOR_PIPELINE_ARTIFACTS))
    error_message = "Bucket name can only contain lowercase letters, numbers, hyphens, and periods."
  }
}

# https://us-east-1.console.aws.amazon.com/codesuite/codestar/project/new?region=us-east-1
variable "CODE_STAR_CONNECTION_ARN" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
  default     = "arn:aws:codeconnections:us-east-1:905418404338:connection/4acf213c-7724-402c-a850-e5ae5da43430"
}


# ----------------------------------------------------------------
# --------------- VPC Configurations VARIABLES -------------------
# --------------- *** Required for Load Balancer ** --------------
# ----------------------------------------------------------------

variable "DEFAULT_VPC_ID" {
  type        = string
  description = "VPC ID used for loadbalancer ..."
  default     = "vpc-0127e7d874b1d47bf"
}

variable "DEFAULT_VPC_SUBNET_ID" {
  type        = list(string)
  description = "Subnets of VPC"
  default     = ["subnet-0f614544fcda5ec34", "subnet-04235934cfc235e61", "subnet-077dc40cd370c3e96", "subnet-061c8c24db41e7991", "subnet-092ae14de48a34df2", "subnet-0a0bc7adaf72b6390"]
}

# ----------------------------------------------------------------
# ------------- ELB (Elastic Load Balancer) VARIABLES ------------
# ----------------------------------------------------------------

variable "ELB_PUBLIC_NAME" {
  type        = string
  description = "Public name of ELB"
  default     = "my-test-elb"
  validation {
    condition     = can(regex("^([a-zA-Z0-9-]+)$", var.ELB_PUBLIC_NAME))
    error_message = "Invalid ELB public name. Only alphanumeric characters and hyphens are allowed."
  }
}

# ----------------------------------------------------------------
# ----------------------- AWS MONTHLY BUDGET ---------------------
# ----------------------------------------------------------------

variable "MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES" {
  description = "List of email addresses for budget notifications"
  type        = list(string)
  default     = ["tameem.rafay@pikessoft.com"]
}

variable "MAX_ACCOUNT_MONTHLY_BUDGET" {
  description = "Maximum monthly budget for the account"
  type        = number
  default     = 30
}

# ----------------------------------------------------------------
# ---------- ECR REPOSITORY DETAILS FOR STORING IMAGE  -----------
# ----------------------------------------------------------------

variable "ECR_REPOSITORY_NAME_FOR_BE" {
  description = "ECR Repository Name for storing the docker images"
  type        = string
  default     = "test-ecr-repo"
}