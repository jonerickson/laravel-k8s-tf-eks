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
data "aws_caller_identity" "current" {}

locals {
    cluster_name = format("%s-%s", var.app_name, random_string.suffix.result)
}

resource "random_string" "suffix" {
    length = 8
    special = false
}

resource "aws_iam_role" "github_actions_role" {
    name = "GithubActionsRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:sub" = "repo:${var.github_organization}/${var.github_repository}:ref:refs/heads/main"
                    }
                }
            }
        ]
    })
}

resource "aws_iam_policy" "github_actions_policy" {
    name        = "GitHubActionsPolicy"
    description = "Permissions for GitHub Actions"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = ["ec2:*", "s3:*", "iam:*", "kms:*", "eks:*"]
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_github_actions_policy" {
    role = aws_iam_role.github_actions_role.name
    policy_arn = aws_iam_policy.github_actions_policy.arn
}

data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
    url  = "https://token.actions.githubusercontent.com"
    thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
    client_id_list  = ["sts.amazonaws.com"]
}

