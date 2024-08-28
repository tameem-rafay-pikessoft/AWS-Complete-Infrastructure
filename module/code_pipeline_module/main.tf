# Create CodeDeploy Application
resource "aws_codedeploy_app" "code_pipeline_app" {
  name             = var.code_deploy_application_name
  compute_platform = "Server" # For EC2 instances
}

# todo: 
# 1. codedeploy-deployment-group
# 2. code build environment_variable

# Create IAM role for AWS CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = var.code_deploy_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codedeploy.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


# Attach IAM policy granting necessary permissions for AWS CodeDeploy to the IAM role
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole" # This is the AWS managed policy for CodeDeploy
}


resource "aws_codedeploy_deployment_group" "codedeploy_group" {
  count                  = var.deployment_config.is_deploy_on_s3_bucket ? 0 : 1
  app_name               = aws_codedeploy_app.code_pipeline_app.name
  deployment_group_name  = "codedeploy-deployment-group"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  autoscaling_groups     = [var.deployment_config.autoscaling_group_name]
}

resource "aws_s3_bucket" "deploy_bucket" {
  count         = var.deployment_config.is_deploy_on_s3_bucket ? 1 : 0
  bucket        = var.deployment_config.deploy_artifacts_bucket_name
  force_destroy = true
  # provider =  "us-east-1" 
  # var.aws_region
}

resource "aws_s3_bucket_public_access_block" "deploy_bucket_block" {
  count  = var.deployment_config.is_deploy_on_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.deploy_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create IAM role for AWS CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = var.code_pipeline_role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Define IAM policy allowing necessary actions on the S3 bucket, CodeDeploy resources, and CodeBuild
resource "aws_iam_policy" "codepipeline_policy" {
  name        = var.codepipeline_policy_name
  description = "IAM policy for CodePipeline to upload artifacts to S3 bucket, deploy applications using CodeDeploy, and start CodeBuild"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*" // Replace '*' with the ARN of your S3 bucket if you want to restrict access to a specific bucket
      },
      {
        "Effect" : "Allow",
        "Action" : "codedeploy:*",
        "Resource" : "*" // Allow CreateDeployment action on all CodeDeploy resources
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach IAM policy to IAM role associated with CodePipeline
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# ------------------------------------------------------------
# Attach IAM policy to IAM role associated with CodePipeline
# ------------------------------------------------------------

resource "aws_iam_role_policy" "codepipeline_assume_role_policy" {
  name = "codepipeline-assume-role-policy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "codestar-connections:UseConnection",
        Resource = "*" // Replace with the ARN of the CodeStar Connection's IAM role
      }
    ]
  })
}

# Attach AWS managed policy for CodePipeline to the IAM role
resource "aws_iam_role_policy_attachment" "codepipeline_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

resource "aws_s3_bucket" "store_pipeline_artifacts_bucket" {
  bucket        = var.S3_BUCKET_FOR_PIPELINE_ARTIFACTS
  force_destroy = true # Delete the bucket even if the Bucket is not destroyed
}

resource "aws_s3_bucket_public_access_block" "store_pipeline_artifacts_bucket_block" {
  bucket = aws_s3_bucket.store_pipeline_artifacts_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create CodePipeline
resource "aws_codepipeline" "code_pipeline" {
  name          = var.AWS_CODE_PIPELINE_NAME
  role_arn      = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"

  dynamic "variable" {
    for_each = var.PipelineVariables
    content {
      name          = variable.key
      default_value = variable.value
    }
  }

  tags = var.tags
  artifact_store {
    location = aws_s3_bucket.store_pipeline_artifacts_bucket.bucket
    type     = "S3"
  }


  stage {
    name = "Source-Stage"

    action {

      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        BranchName           = var.BRANCH_NAME
        FullRepositoryId     = var.FULL_REPOSITORY_ID
        ConnectionArn        = var.CODE_STAR_CONNECTION_ARN
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.code_build.name
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = var.deployment_config.is_deploy_on_s3_bucket ? "S3" : "CodeDeploy"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      configuration = var.deployment_config.is_deploy_on_s3_bucket ? {
        BucketName = var.deployment_config.deploy_artifacts_bucket_name
        ObjectKey  = var.deployment_config.deploy_artifacts_bucket_key
        Extract    = "true"
        } : {
        ApplicationName     = aws_codedeploy_app.code_pipeline_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeploy_group[0].deployment_group_name
      }
    }
  }
}

resource "aws_codestarnotifications_notification_rule" "codepipeline_notifications" {
  detail_type    = "FULL"
  event_type_ids = ["codepipeline-pipeline-pipeline-execution-failed", "codepipeline-pipeline-pipeline-execution-succeeded", "codepipeline-pipeline-pipeline-execution-started"]
  name           = var.pipeline_notification_name
  resource       = aws_codepipeline.code_pipeline.arn
  status         = "ENABLED"

  target {
    address = var.sns_topic_arn
  }
}

# ------------------------------------------------------------
# -------------- BUILD STAGE CONFIGURATIONS ------------
# ------------------------------------------------------------

resource "aws_iam_role" "codebuild_role" {
  name = var.code_build_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each   = toset(var.CodeBuildPolicies)
  role       = aws_iam_role.codebuild_role.name
  policy_arn = each.value
}

resource "aws_cloudwatch_log_group" "codebuild_log_group" {
  name = format("/codebuild/%s", var.AWS_CODE_PIPELINE_NAME)
}

resource "aws_codebuild_project" "code_build" {
  name          = var.code_build_project_name
  description   = "CodeBuild project"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "10"
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = var.codebuild_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
        type  = "PLAINTEXT"
      }
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name  = format("/codebuild/%s", var.AWS_CODE_PIPELINE_NAME)
      stream_name = format("/codebuild/%s", var.AWS_CODE_PIPELINE_NAME)
    }
  }
}



# # ------------------------------------------------------------
# # -------------- BUILD STAGE CONFIGURATIONS ------------
# # ------------------------------------------------------------

# # Create SNS topic
# resource "aws_sns_topic" "codepipeline_notifications" {
#   name = "codepipeline-notifications"
# }

# # Subscribe email to SNS topic
# resource "aws_sns_topic_subscription" "email_subscription" {
#   for_each  = toset(var.codePipeline_notification_email_addresses)
#   topic_arn = aws_sns_topic.codepipeline_notifications.arn
#   protocol  = "email"
#   endpoint  = each.value
# }
