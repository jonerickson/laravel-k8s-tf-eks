output "vpc_id" {
  description = "The AWS VPC ID."
  value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "The AWS VPC private subnet IDs."
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "The AWS VPC public subnet IDs."
  value = module.vpc.public_subnets
}