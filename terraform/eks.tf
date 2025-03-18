module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "19.0.4"

    cluster_name = local.cluster_name
    cluster_version = "1.32"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    cluster_endpoint_public_access = true

    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"
    }

    eks_managed_node_groups = {
        one = {
            name = "node-group-1"

            instance_types = ["t3.small"]

            min_size = 1
            max_size = 3
            desired_size = 1
        }

        two = {
            name = "node-group-2"

            instance_types = ["t3.small"]

            min_size = 1
            max_size = 3
            desired_size = 1
        }
    }
}

resource "aws_eks_fargate_profile" "fargate_profile" {
    count             = var.enable_fargate ? 1 : 0
    cluster_name      = module.eks.cluster_id
    fargate_profile_name = "${local.cluster_name}-fargate-profile"
    pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
    subnet_ids        = var.fargate_subnets
    selectors = [
        {
            namespace = "default"
        }
    ]
}

resource "aws_iam_role" "fargate_pod_execution_role" {
    name = "${local.cluster_name}-fargate-pod-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action    = "sts:AssumeRole",
                Principal = {
                    Service = "eks-fargate-pods.amazonaws.com"
                },
                Effect    = "Allow",
                Sid       = ""
            }
        ]
    })
}
