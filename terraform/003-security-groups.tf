module "eks_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.project_name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  # Ingress Rules (SSH, HTTP, HTTPS)
  ingress_rules = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = concat(
    var.allowed_ingress_cidr,     # For SSH (e.g., ["192.168.0.0/16"])
    ["0.0.0.0/0"]                  # For HTTP and HTTPS
  )

  # Self-referencing SG rule for internal backend traffic on port 8080
  ingress_with_self = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow backend traffic from same SG on port 8080"
    }
  ]

  # Egress: allow all outbound
  egress_rules = ["all-all"]

  tags = {
    Name    = "${var.project_name}-eks-sg"
    Project = var.project_name
    Terraform = "true"
  }
}
