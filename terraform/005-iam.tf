################################################################################
# EKS IAM ROLES FOR EC2-BASED CLUSTER
# ------------------------------------------------------------------------------
# This file creates:
#   - eksClusterRole         → For EKS control plane
#   - eksNodeGroupRole       → For EC2 node groups to join the cluster
# ------------------------------------------------------------------------------
# NOTE: IRSA roles for app-specific access (e.g. DynamoDB, S3) will be added later.
################################################################################
