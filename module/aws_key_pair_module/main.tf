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