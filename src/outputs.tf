output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "eks_admin_role_arn" {
  value       = module.eks_admins_iam_role.this_iam_role_arn
  description = "IAM role ARN for EKS admin access"
}

output "cluster_name" {
  value       = local.cluster_name
  description = "Name of the EKS cluster"
}
