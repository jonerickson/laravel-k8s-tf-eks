module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "19.0.4"

    cluster_name = local.cluster_name
    cluster_version = "1.32"
    cluster_addons = {
        aws-ebs-csi-driver = {
            most_recent = true
        }
    }

    kms_key_administrators = [
        data.aws_caller_identity.current.arn,
        module.iam.github_actions_role,
    ]

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

            iam_role_additional_policies = {
                AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
                AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
            }
        }

        two = {
            name = "node-group-2"

            instance_types = ["t3.small"]

            min_size = 1
            max_size = 3
            desired_size = 1

            iam_role_additional_policies = {
                AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
                AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
            }
        }
    }
}