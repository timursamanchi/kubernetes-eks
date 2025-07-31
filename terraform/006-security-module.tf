module "eks_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.project_name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = local.all_ingress_cidr_rules

  ingress_with_self = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow backend traffic from same SG on port 8080"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Project   = var.project_name
    Terraform = "true"
  }
}
