resource "aws_ssm_parameter" "secure_parameter" {
  name        = var.parameter_store_name
  description = "My secure parameter"
  type        = "SecureString"
  value       = "TEST VALUE AFTER DEPLOYMENT"
  tags        = var.tags
}

# when the project is destroyed the parameter store file should be backup properly 
#  if you don't do this you need to create the parameter store again
resource "null_resource" "example" {
  # DISCLAMIAR: once the resources are created you can not initialized more variables here.
  triggers = {
    parameter_name = aws_ssm_parameter.secure_parameter.name
    aws_region     = "us-east-1" #var.aws_region
    aws_profile    = "test-aws-terraform-Infrastructure" #var.aws_profile
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo '-----' >> parameter_value.txt
      aws ssm get-parameter \
        --name ${self.triggers.parameter_name} \
        --region ${self.triggers.aws_region} \
        --profile ${self.triggers.aws_profile} \
        --query 'Parameter.Value' \
        --with-decryption \
        --output text >> parameter_value.txt
      EOT
  }
}


