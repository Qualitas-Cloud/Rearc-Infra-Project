output "eks_admin_role_arn" {
  value       = module.eks_admins_iam_role.this_iam_role_arn
  description = "IAM role ARN for EKS admin access"
}
