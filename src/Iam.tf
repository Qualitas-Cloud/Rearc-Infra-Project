module "eks_admins_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.3.1"

  role_name         = "eks-admin"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]

  trusted_role_arns = [
    "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
  ]
}

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
  role   = module.eks_admins_iam_role.role_name
  policy = data.aws_iam_policy_document.eks_access.json
}

data "aws_caller_identity" "current" {}
