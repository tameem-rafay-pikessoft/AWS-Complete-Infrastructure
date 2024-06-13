output "instance_details" {
  value = {
    instance_id   = aws_instance.ec2_instance.id
    instance_name = aws_instance.ec2_instance.tags["Name"]
  }
}
output "public_dns" {
  value = aws_instance.ec2_instance.public_dns
}

output "ec2_key_pair_name" {
  description = "The name of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

