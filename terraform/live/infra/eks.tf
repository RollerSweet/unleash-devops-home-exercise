module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.10.1"

  name    = "${var.env}-eks"
  kubernetes_version = var.cluster_version

  endpoint_public_access = true

  addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      before_compute           = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    metrics-server = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    cert-manager = {
      most_recent = true
      configuration_values = jsonencode({
        webhook = {
          hostNetwork = true
        }
      })
    }
  }
  
  node_security_group_additional_rules = {
    cert_manager_webhook_hostnetwork = {
      description                   = "Allow EKS control-plane to reach cert-manager webhook on hostNetwork"
      protocol                      = "tcp"
      from_port                     = 10260
      to_port                       = 10260
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  vpc_id                   = local.vpc_id
  subnet_ids               = local.public_subnets_ids
  control_plane_subnet_ids = local.private_subnets_ids
  
  authentication_mode = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    unleash-np = {
      name           = "${var.env}-np"
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 5
      desired_size = 2      
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
