AWS_REGION      = "us-east-1"
AWS_PROFILE     = "test-aws-terraform-Infrastructure"
SSH_ALLOWED_IP  = "39.44.28.92/32"
PROJECT_NAME    = "test-aws-terraform-Infrastructure"
ENVIRNMENT_NAME = "Development"

AUTO_SCALING_CONFIG = {
  ASG_MIN_SIZE         = 1
  ASG_MAX_SIZE         = 1
  ASG_DESIRED_CAPACITY = 1
}

EC2_CONFIG = {
    EC2_INSTANCE_NAME          = "Test-Project-development"
    EC2_INSTANCE_TYPE          = "t2.micro"
    EC2_INSTANCE_AMI           = "ami-0a3c3a20c09d6f377"
    EC2_INSTANCE_PEM_FILE_NAME = "Test-Project-development"
}

PARAMETER_STORE_NAME                        = "/be/env"
CLOUDWATCH_LOG_GROUP_NAME                   = "/Test-Project-development/log-group"
CLOUDWATCH_LOG_STREAM_NAME                  = "Test-Project-development-log-stream"
DEVELOPERS_NOTIFICATION_EMAIL_ADDRESSES     = ["tameem.rafay@pikessoft.com"]

PIPELINE_CONFIG = {
    FULL_REPOSITORY_ID               = "rafay-tariq/equipx-test-demo"
    AWS_CODE_PIPELINE_NAME           = "equipX-development-BE"
    BRANCH_NAME                      = "master"
    S3_BUCKET_FOR_PIPELINE_ARTIFACTS = "development-test-project-codepipeline-artifacts"
    CODE_STAR_CONNECTION_ARN         = "arn:aws:codeconnections:us-east-1:905418404338:connection/4acf213c-7724-402c-a850-e5ae5da43430"
}
DEFAULT_VPC_ID                              = "vpc-0127e7d874b1d47bf"
DEFAULT_VPC_SUBNET_ID                       = ["subnet-0f614544fcda5ec34", "subnet-04235934cfc235e61", "subnet-077dc40cd370c3e96", "subnet-061c8c24db41e7991", "subnet-092ae14de48a34df2", "subnet-0a0bc7adaf72b6390"]
ELB_PUBLIC_NAME                             = "my-test-elb"
MONTHLY_BUDGET_NOTIFICATION_EMAIL_ADDRESSES = ["tameem.rafay@pikessoft.com"]
MAX_ACCOUNT_MONTHLY_BUDGET                  = 30
ECR_REPOSITORY_NAME_FOR_BE                  = "test-ecr-repo"
