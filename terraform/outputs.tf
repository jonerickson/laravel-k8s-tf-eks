output "app_name" {
    description = "The application name being deployed."
    value = var.app_name
}

output "cluster_name" {
    description = "The AWS EKS cluster name."
    value = module.eks.cluster_name
}

output "cluster_endpoint" {
    description = "The AWS EKS cluster endpoint."
    value = module.eks.cluster_endpoint
}

output "region" {
    description = "The AWS region the cluster is deployed to."
    value = var.region
}

output "cluster_security_group_id" {
    description = "The AWS security group ID for the AWS EKS cluster."
    value = module.eks.cluster_security_group_id
}

output "dns_validation_records" {
    description = "The DNS validation records for the ACM certificate."
    value = aws_acm_certificate.app_certificate.domain_validation_options
}

output "github_actions_role" {
    description = "The GitHub Actions IAM role that can be used to deploy the application."
    value = aws_iam_role.github_actions_role.arn
}

output "ecr_repository_url" {
    description = "The URL of the ECR repository."
    value = aws_ecr_repository.laravel.repository_url
}

output "ecr_repository_id" {
    description = "The ID of the ECR repository."
    value = aws_ecr_repository.laravel.registry_id
}
