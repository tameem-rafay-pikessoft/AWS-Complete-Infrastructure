terraform {
  backend "s3" {
    bucket  = "development-aws-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "test-aws-terraform-Infrastructure"
  }
}