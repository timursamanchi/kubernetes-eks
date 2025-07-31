#######################################
# EKS vpc settings
#######################################
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-1"
}

variable "max_azs" {
  description = "Number of availability zones to use"
  type        = number
  default     = 3
}

variable "project_name" {
  description = "Name prefix for tagging resources"
  type        = string
  default     = "quote-app"
}

variable "allowed_ingress_cidr" {
  description = "List of allowed CIDR blocks for SSH ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"] # restrict in production!
}

# variable "eks_admin_access_entries" {
#   description = "List of IAM users to grant admin access via aws-auth ConfigMap"
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = []
# }
variable "eks_admin_access_entries" {
  description = "Map of IAM access entries for EKS aws-auth"
  type = map(object({
    principal_arn        = string
    kubernetes_username  = string
    kubernetes_groups    = list(string)
    policy_associations  = optional(list(object({
      policy_arn = string
      access_scope = object({
        type       = string
        namespaces = optional(list(string))
      })
    })), [])
  }))
  default = {}
}
