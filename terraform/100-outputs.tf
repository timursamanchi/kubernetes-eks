output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "nat_gateway_ids" {
  value = module.vpc.natgw_ids
}

output "availability_zones" {
  value = local.selected_azs
}
output "public_subnet_cidrs" {
  value = local.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = local.private_subnet_cidrs
}
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
output "quote_frontend_log_group" {
  value = aws_cloudwatch_log_group.quote_frontend.name
}

output "quote_backend_log_group" {
  value = aws_cloudwatch_log_group.quote_backend.name
}
