terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.83"
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
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
        command = "aws"
    }
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
    vpc_id = module.vpc.id
    vpc_private_ids = module.vpc.private_subnets
}

module "helm" {
    source = "./modules/helm"
    depends_on = [module.eks, module.s3, module.ecr, module.acm]
    docker_image = module.ecr.repository_url
    docker_image_repository_name = module.ecr.repository_name
}

module "s3" {
    source = "./modules/s3"
    bucket_name = var.app_name
}

module "vpc" {
    source = "./modules/vpc"
    name = var.app_name
    public_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb" = 1
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb" = 1
    }
}

locals {
    cluster_name = format("%s-%s", var.app_name, random_string.suffix.result)
}

resource "random_string" "suffix" {
    length = 8
    special = false
}

