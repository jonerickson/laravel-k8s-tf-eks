resource "aws_ecr_repository" "my_app_repo" {
  name = "laravel-k8s-tf-eks"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.my_app_repo.repository_url
}