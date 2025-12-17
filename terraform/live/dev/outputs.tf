output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name."
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster API endpoint."
}

output "bucket_name" {
  value       = module.app_bucket.bucket_id
  description = "Application S3 bucket name."
}

output "irsa_role_arn" {
  value       = module.app_irsa.role_arn
  description = "IAM role ARN for the application's Kubernetes service account."
}
