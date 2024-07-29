module "eks_admins_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.3.1"

  role_name         = "eks-admin"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [aws_iam_policy.allow_eks_access.arn]

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]
}

resource "aws_iam_policy" "allow_eks_access" {
  name        = "AllowEKSAccess"
  description = "Policy to allow EKS access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeFargateProfile",
          "eks:ListFargateProfiles"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_access" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster"
    ]
    resources = [
      "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${local.cluster_name}"
    ]
  }
}

resource "aws_iam_role_policy" "eks_access" {
  name   = "eks-access"
  role   = module.eks_admins_iam_role.this_iam_role_name
  policy = data.aws_iam_policy_document.eks_access.json
}
