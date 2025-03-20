variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_ids" {
  type = list(string)
}

variable "deploy_role_arn" {
    type = string
}