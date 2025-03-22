output "app_name" {
    description = "The application name being deployed."
    value = var.app_name
}

output "dns_validation_records" {
    description = "The DNS validation records for the ACM certificate."
    value = [for record in module.acm.dns_validation_records : record]
}

output "load_balancer_url" {
    description = "The URL of the load balancer."
    value = module.eks.cluster_load_balancer_address
}

output "load_balancer_host" {
    description = "The host the load balancer is listening to."
    value = module.eks.cluster_load_balancer_host
}

output "region" {
    description = "The AWS region the cluster is deployed to."
    value = var.region
}

output "ecr_repository_id" {
    description = "The ID of the ECR repository."
    value = module.ecr.repository_id
}

output "ecr_repository_name" {
    description = "The name of the ECR repository."
    value = module.ecr.repository_name
}

output "ecr_repository_url" {
    description = "The URL of the ECR repository."
    value = module.ecr.repository_url
}

output "eks_cluster_endpoint" {
    description = "The AWS EKS cluster endpoint."
    value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
    description = "The AWS EKS cluster name."
    value = module.eks.cluster_name
}

output "s3_public_bucket_name" {
    description = "The name of the public S3 bucket."
    value = module.s3.public_bucket_name
}

output "s3_private_bucket_name" {
    description = "The name of the private S3 bucket."
    value = module.s3.private_bucket_name
}

output "vpc_public_subnets" {
    description = "The list of VPC public subnets."
    value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
    description = "The list of VPC private subnets."
    value = module.vpc.private_subnets
}

output "vpc_availability_zones" {
    description = "The availability zones for the VPC."
    value = [for az in module.vpc.availability_zones : az]
}