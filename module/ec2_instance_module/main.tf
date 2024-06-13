resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ec2_instance_pem_file_name
  public_key = tls_private_key.key.public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.key.private_key_pem}' > ./${var.ec2_instance_pem_file_name}.pem"
  }
  tags = var.tags
}

# Create the role for EC2 instance
resource "aws_iam_role" "EC2_Service_Role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com",
      },
    }],
  })
  tags = var.tags
}

# Attach different policies with EC2 role
resource "aws_iam_role_policy_attachment" "ec2_role_permissions" {
  count      = length(var.ec2_role_permissions)
  policy_arn = var.ec2_role_permissions[count.index]
  role       = aws_iam_role.EC2_Service_Role.name
}

resource "aws_iam_instance_profile" "EC2_instance_profile" {
  name = aws_iam_role.EC2_Service_Role.name
  role = aws_iam_role.EC2_Service_Role.id
  tags = var.tags
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = file("${path.module}/../../Utils/EC2_user_data.sh")
  iam_instance_profile   = aws_iam_instance_profile.EC2_instance_profile.name
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name               = aws_key_pair.ec2_key_pair.key_name #
  tags = merge(var.tags, {
    Name = var.instance_name
  })
}
# -- Assign Elastic IP to EC2 
resource "aws_eip" "aws_instance_elastic_ip" {
  domain   = "vpc"
  instance = aws_instance.ec2_instance.id
  tags     = var.tags
}