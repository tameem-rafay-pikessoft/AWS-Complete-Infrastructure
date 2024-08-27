provider "aws" {
  alias  = "us-east-1"
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE // AWS CLI profile locally
}

locals {
  common_tags = {
    Project_Name = var.PROJECT_NAME
    Environment  = var.ENVIRNMENT_NAME
    Region       = var.AWS_REGION
  }
}

module "parameter_store_module" {
  source               = "./module/parameter_store_module"
  PARAMETER_STORE_NAME = var.PARAMETER_STORE_NAME
  tags                 = local.common_tags
  AWS_REGION           = var.AWS_REGION
  AWS_PROFILE          = var.AWS_PROFILE
}

module "cloudwatch_logs_module" {
  source                     = "./module/cloudwatch_logs_module"
  CLOUDWATCH_LOG_GROUP_NAME  = var.CLOUDWATCH_LOG_GROUP_NAME
  CLOUDWATCH_LOG_STREAM_NAME = var.CLOUDWATCH_LOG_STREAM_NAME
  tags                       = local.common_tags
}

module "aws_max_monthly_budget" {
  source                                      = "./module/aws_account_monthly_budget_module"
  MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES = var.MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES
  MAX_ACCOUNT_MONTHLY_BUDGET                  = var.MAX_ACCOUNT_MONTHLY_BUDGET
  tags                                        = local.common_tags
}

module "aws_cloudwatch_resource_monitoring_alerts" {
  source                            = "./module/cloud_watch_alerts"
  cloudwatch_alerts_email_addresses = var.DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES
  autoscaling_group_name            = module.ec2_auto_scaling_BE_module.autoscaling_group_name
  tags                              = local.common_tags
}

module "aws_ecr_repository_for_BE_module" {
  source                     = "./module/ecr_repository"
  ECR_REPOSITORY_NAME_FOR_BE = var.ECR_REPOSITORY_NAME_FOR_BE
  tags                       = local.common_tags
}

module "load_balancer_module" {
  source                = "./module/load_balancer_module"
  DEFAULT_VPC_SUBNET_ID = var.DEFAULT_VPC_SUBNET_ID
  DEFAULT_VPC_ID        = var.DEFAULT_VPC_ID
  ELB_PUBLIC_NAME       = var.ELB_PUBLIC_NAME
  tags                  = local.common_tags
}

module "ec2_security_group_for_auto_scaling_module" {
  source                = "./module/security_group_module"
  elb_security_group_id = module.load_balancer_module.elb_security_group_id
  SSH_ALLOWED_IP        = var.SSH_ALLOWED_IP
  tags                  = local.common_tags
}

module "aws_key_pair_module" {
  source                     = "./module/aws_key_pair_module"
  EC2_INSTANCE_PEM_FILE_NAME = var.EC2_CONFIG.EC2_INSTANCE_PEM_FILE_NAME
  tags                       = local.common_tags
}

module "sns_topic_module" {
  source                       = "./module/sns_topic"
  tags                         = local.common_tags
  notification_email_addresses = var.DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES
}


# module "ec2_instance_module" {
#   source                     = "./module/ec2_instance_module"
#   ami                        = var.EC2_INSTANCE_AMI # ami: aws linux machine
#   instance_type              = var.EC2_INSTANCE_TYPE
#   instance_name              = var.EC2_INSTANCE_NAME
#   # EC2_INSTANCE_PEM_FILE_NAME = var.EC2_INSTANCE_PEM_FILE_NAME
#   ec2_key_pair_name          = module.aws_key_pair_module.ec2_key_pair_name
#   ec2_security_group_id      = module.ec2_security_group_for_auto_scaling_module.security_group_id
#   SSH_ALLOWED_IP             = var.SSH_ALLOWED_IP
#   tags                       = local.common_tags
# }

module "ec2_auto_scaling_BE_module" {
  source                = "./module/auto_scaling_group_module"
  instance_type         = var.EC2_CONFIG.EC2_INSTANCE_TYPE
  ami                   = var.EC2_CONFIG.EC2_INSTANCE_AMI
  DEFAULT_VPC_SUBNET_ID = var.DEFAULT_VPC_SUBNET_ID
  elb_security_group_id = module.load_balancer_module.elb_security_group_id
  ec2_security_group_id = module.ec2_security_group_for_auto_scaling_module.security_group_id
  ec2_key_pair_name     = module.aws_key_pair_module.ec2_key_pair_name
  target_group_arn      = module.load_balancer_module.target_group_arn
  ASG_MIN_SIZE          = var.AUTO_SCALING_CONFIG.ASG_MIN_SIZE
  ASG_MAX_SIZE          = var.AUTO_SCALING_CONFIG.ASG_MAX_SIZE
  ASG_DESIRED_CAPACITY  = var.AUTO_SCALING_CONFIG.ASG_DESIRED_CAPACITY
  DEFAULT_VPC_ID        = var.DEFAULT_VPC_ID
  tags                  = local.common_tags
}

module "code_pipeline_BE_module" {
  source                 = "./module/code_pipeline_module"
  AWS_CODE_PIPELINE_NAME = var.BE_PIPELINE_CONFIG.AWS_CODE_PIPELINE_NAME
  PipelineVariables = {
    "ECR_REPOSITORY_URI" = module.aws_ecr_repository_for_BE_module.ecr_repository_url
  }
  sns_topic_arn = module.sns_topic_module.sns_topic_arn
  deployment_config = {
    is_deploy_on_s3_bucket = false
    autoscaling_group_name = module.ec2_auto_scaling_BE_module.autoscaling_group_name
  }
  codepipeline_policy_name                  = var.BE_PIPELINE_CONFIG.CODE_PIPELINE_POLICY_NAME
  code_build_project_name                   = var.BE_PIPELINE_CONFIG.CODE_BUILD_PROJECT_NAME
  code_deploy_role_name                     = var.BE_PIPELINE_CONFIG.CODE_DEPLOY_ROLE_NAME
  code_pipeline_role_name                   = var.BE_PIPELINE_CONFIG.CODE_PIPELINE_ROLE_NAME
  code_build_role_name                      = var.BE_PIPELINE_CONFIG.CODE_BUILD_ROLE_NAME
  code_deploy_application_name              = var.BE_PIPELINE_CONFIG.CODE_DEPLOY_APPLICATION_NAME
  FULL_REPOSITORY_ID                        = var.BE_PIPELINE_CONFIG.FULL_REPOSITORY_ID
  BRANCH_NAME                               = var.BE_PIPELINE_CONFIG.BRANCH_NAME
  CODE_STAR_CONNECTION_ARN                  = var.BE_PIPELINE_CONFIG.CODE_STAR_CONNECTION_ARN
  S3_BUCKET_FOR_PIPELINE_ARTIFACTS          = var.BE_PIPELINE_CONFIG.S3_BUCKET_FOR_PIPELINE_ARTIFACTS
  pipeline_notification_name                = var.BE_PIPELINE_CONFIG.PIPELINE_NOTIFICATION_NAME
  codePipeline_notification_email_addresses = var.DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES
  aws_region                                = var.AWS_REGION
  tags                                      = local.common_tags
}

# ----------------------------------------------------------------
# ---------------------- FrontEnd Admin Panel --------------------
# ----------------------------------------------------------------


module "s3_cloudfront_for_admin_panel" {
  source      = "./module/s3_cloudfront_module"
  bucket_name = var.CLOUD_FRONT_WITH_S3_ADMIN_PANEL_CONFIG.S3_BUCKET_NAME
  origin_id   = var.CLOUD_FRONT_WITH_S3_ADMIN_PANEL_CONFIG.ORIGIN_ID
  price_class = var.CLOUD_FRONT_WITH_S3_ADMIN_PANEL_CONFIG.PRICE_CLASS
  aws_region  = var.AWS_REGION
  tags        = local.common_tags
}

module "code_pipeline_FE_Admin_panel_module" {
  source                 = "./module/code_pipeline_module"
  AWS_CODE_PIPELINE_NAME = var.ADMIN_PANEL_PIPELINE_CONFIG.AWS_CODE_PIPELINE_NAME
  PipelineVariables = {
    "ECR_REPOSITORY_URI" = module.aws_ecr_repository_for_BE_module.ecr_repository_url
  }
  deployment_config = {
    is_deploy_on_s3_bucket       = true
    deploy_artifacts_bucket_name = var.ADMIN_PANEL_PIPELINE_CONFIG.DEPLOY_ARTIFACTS_BUCKET_NAME
    deploy_artifacts_bucket_key  = var.ADMIN_PANEL_PIPELINE_CONFIG.DEPLOY_ARTIFACTS_BUCKET_KEY

  }
  codepipeline_policy_name                  = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_PIPELINE_POLICY_NAME
  code_build_project_name                   = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_BUILD_PROJECT_NAME
  code_deploy_role_name                     = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_DEPLOY_ROLE_NAME
  code_pipeline_role_name                   = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_PIPELINE_ROLE_NAME
  code_build_role_name                      = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_BUILD_ROLE_NAME
  code_deploy_application_name              = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_DEPLOY_APPLICATION_NAME
  sns_topic_arn                             = module.sns_topic_module.sns_topic_arn
  FULL_REPOSITORY_ID                        = var.ADMIN_PANEL_PIPELINE_CONFIG.FULL_REPOSITORY_ID
  BRANCH_NAME                               = var.ADMIN_PANEL_PIPELINE_CONFIG.BRANCH_NAME
  CODE_STAR_CONNECTION_ARN                  = var.ADMIN_PANEL_PIPELINE_CONFIG.CODE_STAR_CONNECTION_ARN
  S3_BUCKET_FOR_PIPELINE_ARTIFACTS          = var.ADMIN_PANEL_PIPELINE_CONFIG.S3_BUCKET_FOR_PIPELINE_ARTIFACTS
  codePipeline_notification_email_addresses = var.DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES
  pipeline_notification_name                = var.ADMIN_PANEL_PIPELINE_CONFIG.PIPELINE_NOTIFICATION_NAME
  aws_region                                = var.AWS_REGION
  tags                                      = local.common_tags
}



# ----------------------------------------------------------------
# ---------------------- OUTPUT SECTION --------------------------
# ----------------------------------------------------------------

# output "s3_cloudfront_for_admin_panel" {
#   value = module.s3_cloudfront_for_admin_panel.cloudfront_distribution_url
# }

output "PARAMETER_STORE_NAME" {
  value = module.parameter_store_module.PARAMETER_STORE_NAME
}

output "cloudwatch_logs_group_name" {
  value = module.cloudwatch_logs_module.cloudwatch_group_name
}

output "cloudwatch_stream_name" {
  value = module.cloudwatch_logs_module.cloudwatch_stream_name
}

# todo: fix cloudwatch monitoring of ec2 instance
# todo: fix code pipeline error notification

output "load_balancer_dns" {
  value = module.load_balancer_module.load_balancer_url
}


# output "module_ec2_instance_details" {
#   value = module.ec2_instance_module.instance_details
# }

# output "ec2_instance_ssh_details" {
#   value = "ssh -i ~/Downloads/${var.EC2_INSTANCE_PEM_FILE_NAME}.pem ec2-user@${module.ec2_instance_module.public_dns}"
# }
