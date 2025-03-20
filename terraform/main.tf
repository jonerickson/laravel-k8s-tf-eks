terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.16"
        }

        random = {
            source = "hashicorp/random"
            version = "~> 3.4.3"
        }

        tls = {
            source = "hashicorp/tls"
            version = "~> 4.0.4"
        }

        cloudinit = {
            source = "hashicorp/cloudinit"
            version = "~> 2.2.0"
        }

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.16.1"
        }
    }

    required_version = ">= 1.3.0"
}

provider "aws" {
    region = var.region
}

provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "helm" {
    kubernetes {
        host = module.eks.cluster_endpoint
        cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
            command = "aws"
        }
    }
}

module "acm" {
    source = "./modules/acm"
    host = var.host
}

module "ecr" {
    source = "./modules/ecr"
    repository_name = var.repository_name
}

module "eks" {
    source = "./modules/eks"
    cluster_name = local.cluster_name
    region = var.region
    vpc_id = module.vpc.vpc_id
    vpc_private_ids = module.vpc.vpc_private_subnets
    deploy_role_arn = module.iam.github_actions_role_arn
}

module "iam" {
    source = "./modules/iam"
    github_organization = var.github_organization
    github_repository = var.github_repository
}

module "vpc" {
    source = "./modules/vpc"
    app_name = var.app_name
    cluster_name = local.cluster_name
}

locals {
    cluster_name = format("%s-%s", var.app_name, random_string.suffix.result)
}

resource "random_string" "suffix" {
    length = 8
    special = false
}

