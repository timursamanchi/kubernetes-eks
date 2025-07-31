#######################################
# Get available AZs
#######################################
data "aws_availability_zones" "available" {
  state = "available"
}

#######################################
# Subnet and AZ logic
#######################################
locals {
  # Pick first N availability zones
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.max_azs)

  # Create public subnets (3 bits → 8 total subnets possible from /22)
  public_subnet_cidrs = [
    for i in range(length(local.selected_azs)) :
    cidrsubnet(var.cidr_block, 3, i)
  ]

  # Create private subnets starting after public ones
  private_subnet_cidrs = [
    for i in range(length(local.selected_azs)) :
    cidrsubnet(var.cidr_block, 3, i + length(local.selected_azs))
  ]

  #######################################
  # Security Group Ingress Rules
  #######################################

  ingress_cidr_ssh = [
    for cidr in var.allowed_ingress_cidr : {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH from allowed CIDRs"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_cidr_http_https = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP from internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS from internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  all_ingress_cidr_rules = concat(local.ingress_cidr_ssh, local.ingress_cidr_http_https)
}
