output "id" {
  description = "The AWS VPC ID."
  value       = module.vpc.vpc_id
}

output "availability_zones" {
  description = "The availability zones for the VPC."
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "The AWS VPC private subnet IDs."
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The AWS VPC public subnet IDs."
  value       = module.vpc.public_subnets
}