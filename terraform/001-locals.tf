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
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.max_azs)

  # Extension 3 bits = 8 subnets possible (/25)
  public_subnet_cidrs = [
    for i in range(length(local.selected_azs)) :
    cidrsubnet(var.cidr_block, 3, i)
  ]

  private_subnet_cidrs = [
    for i in range(length(local.selected_azs)) :
    cidrsubnet(var.cidr_block, 3, i + length(local.selected_azs))
  ]
}