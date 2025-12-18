output "role_arn" {
    description = "arn for sa"
    value = aws_iam_role.app_iam_role.arn
}

output "bucket_name" {
  description = "S3 bucket name for the app"
  value       = aws_s3_bucket.app_bucket.bucket
}