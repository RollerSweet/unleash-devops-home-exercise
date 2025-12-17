output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs of public subnets."
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs of private subnets."
  value       = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr_block
}
