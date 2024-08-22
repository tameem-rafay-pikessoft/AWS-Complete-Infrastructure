resource "aws_ssm_parameter" "secure_parameter" {
  name        = var.PARAMETER_STORE_NAME
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
    AWS_REGION     = var.AWS_REGION  #var.AWS_REGION
    AWS_PROFILE    = var.AWS_PROFILE #var.AWS_PROFILE
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo '-----' >> parameter_value.txt
      aws ssm get-parameter \
        --name ${self.triggers.parameter_name} \
        --region ${self.triggers.AWS_REGION} \
        --profile ${self.triggers.AWS_PROFILE} \
        --query 'Parameter.Value' \
        --with-decryption \
        --output text >> parameter_value.txt
      EOT
  }
}


