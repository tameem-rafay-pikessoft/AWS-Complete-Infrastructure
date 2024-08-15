output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.my_ecr_repo.name
}

# e.g. 285340563700.dkr.ecr.us-east-1.amazonaws.com/equipx-be-prod
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}