resource "aws_ecr_repository" "laravel" {
  name = var.repository_name
}