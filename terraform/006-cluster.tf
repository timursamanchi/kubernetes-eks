################################################################################
# 006-EKS-CLUSTER.TF
# ------------------------------------------------------------------------------
# Provisions an EKS cluster using EC2 worker nodes (managed node group)
# IAM roles are auto-managed by the EKS module
# Includes core add-ons (CoreDNS, kube-proxy, VPC CNI) and CloudWatch log group
################################################################################
################################################################################
# 006-EKS-CLUSTER.TF
# ------------------------------------------------------------------------------
# Provisions an EKS cluster using EC2 worker nodes (managed node group)
# IAM roles are auto-managed by the EKS module
# Uses EKS API authentication (no manual aws-auth patching)
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  authentication_mode = "API"
  access_entries      = var.eks_admin_access_entries

  cluster_endpoint_public_access = true
  enable_irsa                    = true
  create_iam_role                = true
  create_node_iam_role           = true
  cluster_security_group_id      = module.eks_security_group.security_group_id

  eks_managed_node_groups = {
    quoteapp_nodes = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.small"]
      disk_size      = 30
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      labels = {
        role = "worker"
        app  = "quoteapp"
      }

      tags = {
        Name = "quoteapp-node"
      }
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  create_cloudwatch_log_group              = true
  cloudwatch_log_group_retention_in_days  = 7

  tags = {
    Project   = var.project_name
    Terraform = "true"
  }
}
