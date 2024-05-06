provider "aws" {
  region  = var.aws_region
  profile = "test-aws-terraform-Infrastructure" // AWS CLI profile locally
}

locals {
  common_tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = var.account_id
    Region       = var.aws_region
  }
}

module "parameter_store_module" {
  source               = "./module/parameter_store_module"
  parameter_store_name = var.parameter_store_name
  tags                 = local.common_tags
}

module "cloudwatch_logs_module" {
  source                     = "./module/cloudwatch_logs_module"
  cloudwatch_log_group_name  = var.cloudwatch_log_group_name
  cloudwatch_log_stream_name = var.cloudwatch_log_stream_name
  tags                       = local.common_tags
}

module "aws_max_monthly_budget" {
  source                                      = "./module/aws_account_monthly_budget_module"
  monthly_budget_notification_email_addresses = var.monthly_budget_notification_email_addresses
  max_account_monthly_budget                  = var.max_account_monthly_budget
  tags                                        = local.common_tags
}

module "load_balancer_module" {
  source          = "./module/load_balancer_module"
  VPC_Subnets_ids = var.VPC_Subnets_ids
  VPC_ID          = var.VPC_ID
  tags            = local.common_tags
  elb_public_name = var.elb_public_name
}


module "ec2_instance_module" {
  source                     = "./module/ec2_instance_module"
  ami                        = var.ec2_instance_ami # ami: aws linux machine
  instance_type              = var.ec2_instance_type
  instance_name              = var.ec2_instance_name
  ssh_allowed_ip             = var.ssh_allowed_ip
  ec2_instance_pem_file_name = var.ec2_instance_pem_file_name
  tags                       = local.common_tags
}

module "ec2_auto_scaling_module" {
  source                = "./module/auto_scaling_group_module"
  instance_type         = var.ec2_instance_type
  ami                   = var.ec2_instance_ami
  VPC_Subnets_ids       = var.VPC_Subnets_ids
  elb_security_group_id = module.load_balancer_module.elb_security_group_id
  VPC_ID                = var.VPC_ID
  tags                  = local.common_tags
}

module "code_pipeline_module" {
  source                   = "./module/code_pipeline_module"
  AWSCodePipeLineName      = var.AWSCodePipeLineName
  instance_name            = module.ec2_instance_module.instance_details.instance_name
  FullRepositoryId         = var.FullRepositoryId
  BranchName               = var.BranchName
  CodeStarConnectionArn    = var.CodeStarConnectionArn
  s3BucketNameForArtifacts = var.s3BucketNameForArtifacts
  tags                     = local.common_tags
}




# ----------------------------------------------------------------
# ---------------------- OUTPUT SECTION --------------------------
# ----------------------------------------------------------------


output "parameter_store_name" {
  value = module.parameter_store_module.parameter_store_name
}

output "cloudwatch_logs_group_name" {
  value = module.cloudwatch_logs_module.cloudwatch_group_name
}

output "cloudwatch_stream_name" {
  value = module.cloudwatch_logs_module.cloudwatch_stream_name
}

output "load_balancer_dns" {
  value = module.load_balancer_module.load_balancer_url
}


output "module_ec2_instance_details" {
  value = module.ec2_instance_module.instance_details
}

output "ec2_instance_ssh_details" {
  value = "ssh -i ~/Downloads/${var.ec2_instance_pem_file_name}.pem ec2-user@${module.ec2_instance_module.public_dns}"
}
