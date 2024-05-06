variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}

# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------


variable "ssh_allowed_ip" {
  type    = string
  default = "103.48.1.30/32"
}



# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------



variable "project_name" {
  type    = string
  default = "test-aws-terraform-Infrastructure"
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "account_id" {
  type    = string
  default = "905418404338"
}

# ----------------------------------------------------------------
# --------------- EC2 VARIABLES ------------------
# ----------------------------------------------------------------

variable "ec2_instance_name" {
  type        = string
  description = "Name of the AWS EC2 instance name"
  default     = "Test-Project-development"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type e.g. micro, nano, large ... "
  default     = "t2.micro"
}
variable "ec2_instance_ami" {
  type        = string
  description = "Name of the AWS EC2 instance name"
  default     = "ami-0a3c3a20c09d6f377"
}

variable "ec2_instance_pem_file_name" {
  type        = string
  description = "name of .pem file for EC2 instance"
  default     = "Test-Project-development"
}

# ----------------------------------------------------------------
# --------------- AWS PARAMETER STORE VARIABLES ------------------
# ----------------------------------------------------------------

variable "parameter_store_name" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
  default     = "/be/env"
}

# ----------------------------------------------------------------
# --------------- Cloudwatch VARIABLES ------------------
# ----------------------------------------------------------------

variable "cloudwatch_log_group_name" {
  type        = string
  description = "Name of the cloudwatch log group"
  default     = "/Test-Project-development/log-group"
}

variable "cloudwatch_log_stream_name" {
  type        = string
  description = "Name of the cloudwatch log stream"
  default     = "Test-Project-development-log-stream"
}

# ----------------------------------------------------------------
# --------------- AWS CodePipeline VARIABLES ---------------------
# ----------------------------------------------------------------

variable "FullRepositoryId" {
  type        = string
  description = "Repository used in code pipeline"
  default     = "TheEquipGroup/equipx_be"
}

variable "AWSCodePipeLineName" {
  type        = string
  description = "Name of AWS code pipeline name"
  default     = "equipX-development-BE"
}

variable "BranchName" {
  type        = string
  description = "Select branch from repository "
  default     = "development"
}

variable "s3BucketNameForArtifacts" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
  default     = "development-test-project-codepipeline-artifacts"
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.s3BucketNameForArtifacts))
    error_message = "Bucket name can only contain lowercase letters, numbers, hyphens, and periods."
  }
}

# https://us-east-1.console.aws.amazon.com/codesuite/codestar/project/new?region=us-east-1
variable "CodeStarConnectionArn" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
  default     = "arn:aws:codestar-connections:us-east-1:730335344990:connection/46c77192-2db7-4df3-9306-be81f191c928"
}


# ----------------------------------------------------------------
# --------------- VPC Configurations VARIABLES -------------------
# --------------- *** Required for Load Balancer ** --------------
# ----------------------------------------------------------------

variable "VPC_ID" {
  type        = string
  description = "VPC ID used for loadbalancer ..."
  default     = "vpc-0127e7d874b1d47bf"
}

variable "VPC_Subnets_ids" {
  type        = list(string)
  description = "Subnets of VPC"
  default     = ["subnet-0f614544fcda5ec34", "subnet-04235934cfc235e61", "subnet-077dc40cd370c3e96", "subnet-061c8c24db41e7991", "subnet-092ae14de48a34df2", "subnet-0a0bc7adaf72b6390"]
}

# ----------------------------------------------------------------
# ------------- ELB (Elastic Load Balancer) VARIABLES ------------
# ----------------------------------------------------------------

variable "elb_public_name" {
  type        = string
  description = "Public name of ELB"
  default     = "my-test-elb"
  validation {
    condition     = can(regex("^([a-zA-Z0-9-]+)$", var.elb_public_name))
    error_message = "Invalid ELB public name. Only alphanumeric characters and hyphens are allowed."
  }
}