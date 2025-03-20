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

provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
    region = var.region
}

data "aws_availability_zones" "available" {}

locals {
    cluster_name = format("%s-%s", var.app_name, random_string.suffix.result)
}

resource "random_string" "suffix" {
    length = 8
    special = false
}

module "ecr" {
    source = "./modules/ecr"
    repository_name = var.repository_name
}

module "iam" {
    source = "./modules/iam"
    github_organization = var.github_organization
    github_repository = var.github_repository
}

