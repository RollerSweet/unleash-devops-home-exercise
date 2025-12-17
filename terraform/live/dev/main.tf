terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }

  backend "s3" {
    bucket         = "unleash-home-exercise-tm-tf-state-clever-turtle"
    key            = "unleash-home-exercise-tm-eks.tfstate"
    region         = "us-east-1"
    dynamodb_table = "unleash-home-exercise-tm-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "unleash-home-exercise"
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  azs       = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, length(var.private_subnet_cidrs))
  admin_arn = var.cluster_admin_arn != null ? var.cluster_admin_arn : data.aws_caller_identity.current.arn
}

module "vpc" {
  source = "../../modules/vpc"

  name               = "${var.project}-vpc"
  cidr               = var.vpc_cidr
  azs                = local.azs
  private_subnets    = var.private_subnet_cidrs
  public_subnets     = var.public_subnet_cidrs
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = var.env
  }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name                          = "${var.project}-${var.env}"
  cluster_version                       = var.cluster_version
  vpc_id                                = module.vpc.vpc_id
  private_subnet_ids                    = module.vpc.private_subnets
  public_subnet_ids                     = module.vpc.public_subnets
  node_group_min_size                   = var.node_group_min_size
  node_group_max_size                   = var.node_group_max_size
  node_group_desired_size               = var.node_group_desired_size
  node_instance_types                   = var.node_instance_types
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  tags = {
    Environment = var.env
  }
}

module "app_bucket" {
  source = "../../modules/app-bucket"

  bucket_name   = var.app_bucket_name
  force_destroy = var.bucket_force_destroy
  tags = {
    Purpose     = "app-storage"
    Environment = var.env
  }
}

module "app_irsa" {
  source = "../../modules/irsa"

  role_name            = "${var.project}-app-irsa-${var.env}"
  oidc_provider_arn    = module.eks.oidc_provider_arn
  namespace            = var.app_namespace
  service_account_name = var.app_service_account
  bucket_arn           = module.app_bucket.bucket_arn

  tags = {
    Environment = var.env
  }
}

data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.33"

  providers = {
    kubernetes = kubernetes.eks
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.eks.node_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = local.admin_arn
      username = "cluster-admin"
      groups   = ["system:masters"]
    }
  ]

  depends_on = [module.eks]
}
