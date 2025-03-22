terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  kms_key_administrators = [
    data.aws_caller_identity.current.arn,
    var.deploy_role_arn,
  ]

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.vpc_private_ids
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AWSLoadBalancerControllerIAMPolicy = aws_iam_policy.elb_controller_policy.arn
      }
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AWSLoadBalancerControllerIAMPolicy = aws_iam_policy.elb_controller_policy.arn
      }
    }
  }
}

data "aws_caller_identity" "current" {}

data "http" "elb_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "elb_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = data.http.elb_controller_policy.response_body
}

resource "helm_release" "elb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.2"
  depends_on = [module.eks]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "awsRegion"
    value = var.region
  }
  set {
    name  = "serviceAccount.create"
    value = "falsw"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}

data "external" "elb_endpoint" {
  program = [
    "bash", "-c", <<EOT
  echo '{"address": "'$(kubectl get ingress app -n default -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')'",
"host": "'$(kubectl get ingress app -n default -o jsonpath='{.spec.rules[0].host}')'"}'
EOT
  ]
}