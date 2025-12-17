variable "role_name" {
  description = "Name of the IAM role to create."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS cluster OIDC provider."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the service account."
  type        = string
}

variable "service_account_name" {
  description = "Service account name that will assume this role."
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket to allow access to."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
