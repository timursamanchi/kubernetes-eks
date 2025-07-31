# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 19.0"

#   cluster_name    = "${var.project_name}-eks"
#   cluster_version = "1.29"

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   # Enables IAM Roles for Service Accounts (OIDC)
#   enable_irsa = true

#   # Allow access to EKS API from the public internet
#   cluster_endpoint_public_access = true

#   # Recommended add-ons
#   cluster_addons = {
#     coredns = {
#       resolve_conflicts = "OVERWRITE"
#     }
#     kube-proxy = {
#       resolve_conflicts = "OVERWRITE"
#     }
#     vpc-cni = {
#       resolve_conflicts = "OVERWRITE"
#     }
#   }

#   # Optional: for fluentbit or EKS control plane logs
#   create_cloudwatch_log_group = true
#   cloudwatch_log_group_retention_in_days = 7

#   tags = {
#     Project   = var.project_name
#     Terraform = "true"
#   }
# }
