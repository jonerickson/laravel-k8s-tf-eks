output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value = aws_ecr_repository.laravel.repository_url
}

output "ecr_repository_id" {
  description = "The ID of the ECR repository."
  value = aws_ecr_repository.laravel.registry_id
}