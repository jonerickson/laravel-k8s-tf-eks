output "repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.laravel.repository_url
}

output "repository_id" {
  description = "The ID of the ECR repository."
  value       = aws_ecr_repository.laravel.registry_id
}

output "repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.laravel.name
}