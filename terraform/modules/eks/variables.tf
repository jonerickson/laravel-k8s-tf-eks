variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "The AWS region where the EKS cluster should be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster should be deployed."
  type        = string
}

variable "vpc_private_ids" {
  description = "The list of private subnet IDs the EKS cluster will be deployed to."
  type = list(string)
}

variable "deploy_role_arn" {
  description = "The ARN of the IAM role that EKS will use to create resources."
  type        = string
}