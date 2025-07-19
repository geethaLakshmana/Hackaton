# terraform/modules/eks/main.tf
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16" # Keep this version or update to the latest compatible one

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  cluster_security_group_tags = {
    Name = "${var.project_name}-eks-sg"
  }

  # EKS Worker Node Group
  eks_managed_node_groups = {
    default = {
      desired_size = var.desired_size
      max_size     = var.max_size
      min_size     = var.min_size

      instance_types = var.instance_types
      subnet_ids     = var.private_subnet_ids # Worker nodes in private subnets
      capacity_type  = "ON_DEMAND"
    }
  }

  # Enable EKS Control Plane Logging to CloudWatch
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    "mapRoles" = yamlencode([
      {
        # The module creates the IAM role, and its ARN will be available via module.eks_cluster.eks_managed_node_groups["default"].iam_role_arn
        "rolearn"  = module.eks_cluster.eks_managed_node_groups["default"].iam_role_arn
        "username" = "system:node:{{EC2PrivateDNSName}}"
        "groups"   = ["system:bootstrappers", "system:nodes"]
      }
    ])
  }
}