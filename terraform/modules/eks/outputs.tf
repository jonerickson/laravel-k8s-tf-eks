output "cluster_name" {
  description = "The AWS EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The AWS EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "The AWS EKS security group ID."
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with your cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_load_balancer_host" {
  description = "The load balancer host for the EKS cluster."
  value       = data.external.elb_endpoint.result["host"]
}

output "cluster_load_balancer_address" {
  description = "The load balancer address for the EKS cluster."
  value       = data.external.elb_endpoint.result["address"]
}