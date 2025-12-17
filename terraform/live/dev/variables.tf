variable "project" {
  description = "Project name used for resource prefixes."
  type        = string
  default     = "unleash-home-exercise"
}

variable "env" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy resources to."
  type        = string
  default     = "us-east-1"
}

variable "cluster_version" {
  description = "EKS cluster version."
  type        = string
  default     = "1.34"
}

variable "cluster_admin_arn" {
  description = "IAM user or role ARN to grant cluster-admin permissions. Defaults to the caller identity."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Override list of AZs. Leave empty to auto select."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "node_group_min_size" {
  description = "Minimum nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum nodes in the managed node group."
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired nodes in the managed node group."
  type        = number
  default     = 2
}

variable "node_instance_types" {
  description = "Instance types for worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Grant the Terraform caller cluster-admin permissions via access entry."
  type        = bool
  default     = true
}

variable "app_bucket_name" {
  description = "Name of the S3 bucket used by the application."
  type        = string
  default     = "unleash-home-exercise-bucket-dev"
}

variable "bucket_force_destroy" {
  description = "Allow bucket deletions even if it contains objects."
  type        = bool
  default     = false
}

variable "app_namespace" {
  description = "Kubernetes namespace of the application."
  type        = string
  default     = "unleash"
}

variable "app_service_account" {
  description = "Service account name for the application."
  type        = string
  default     = "unleash-home-exercise"
}
