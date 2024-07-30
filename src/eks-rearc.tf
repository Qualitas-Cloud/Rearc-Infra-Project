module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    cluster = "rearc_eks"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.small"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}

module "eks_admins_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.3.1"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  create_role = true

  role_name         = "eks-admin"
  role_requires_mfa = false

  custom_role_policy_arns = [aws_iam_policy.allow_eks_access.arn]
  number_of_custom_role_policy_arns = 1
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
  role   = module.eks_admins_iam_role.role.name
  policy = data.aws_iam_policy_document.eks_access.json
}
