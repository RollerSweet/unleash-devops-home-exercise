locals {
  tags = merge(
    {
      Module = "eks"
    },
    var.tags
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.33"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_irsa                     = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = var.node_ami_type
    instance_types = var.node_instance_types
  }

  eks_managed_node_groups = {
    default = {
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size
      subnet_ids   = var.private_subnet_ids
    }
  }

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  tags = local.tags
}
