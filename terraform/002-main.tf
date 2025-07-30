#######################################
# VPC Module with NAT
#######################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = var.cidr_block

  azs              = local.selected_azs
  public_subnets   = local.public_subnet_cidrs
  private_subnets  = local.private_subnet_cidrs

  enable_dns_hostnames = true
  enable_dns_support   = true

  # ✅ NAT for private subnets
  enable_nat_gateway = true
  single_nat_gateway = true  # saves cost (1 NAT for all)

  tags = {
    Project   = "eks"
    Terraform = "true"
  }
}