# output "irsa" {
#     description = "arn for sa"
#     value = aws_iam_role.app_iam_role.arn
# }

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}
