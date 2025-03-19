resource "aws_ecr_repository" "laravel" {
  name = var.repository_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.laravel.repository_url
}