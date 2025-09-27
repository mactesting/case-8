module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.17" # supports EKS 1.32

  cluster_name    = "${var.project}-eks"
  cluster_version = var.eks_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2_x86_64" # or BOTTLEROCKET_x86_64 / AL2023_x86_64
      instance_types = ["t3.medium"]
      min_size       = var.node_min
      max_size       = var.node_max
      desired_size   = var.node_desired

      # Better IP utilization for many pods
      enable_efa = false
      labels     = { "workload" = "general" }
      tags       = { "Name" = "${var.project}-mng" }
    }
  }

  cluster_addons = {
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    kube-proxy = { most_recent = true }
    coredns    = { most_recent = true }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# 