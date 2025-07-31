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
}

#######################################
# CloudWatch Log Groups
#######################################
resource "aws_cloudwatch_log_group" "quote_frontend" {
  name              = "/eks/quote-frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "quote_backend" {
  name              = "/eks/quote-backend"
  retention_in_days = 7
}
