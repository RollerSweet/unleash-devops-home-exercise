variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster."
  type        = string
  default     = "1.34"
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for control plane if needed."
  type        = list(string)
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the default node group."
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the default node group."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the default node group."
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_ami_type" {
  description = "AMI type for the managed node group."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to grant the Terraform caller admin access via EKS access entry."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the EKS resources."
  type        = map(string)
  default     = {}
}
