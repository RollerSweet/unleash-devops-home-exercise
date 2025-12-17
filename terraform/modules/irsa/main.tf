data "aws_caller_identity" "current" {}

locals {
  provider_path = replace(
    var.oidc_provider_arn,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/",
    ""
  )

  service_account_sub = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
  bucket_resources    = [var.bucket_arn, "${var.bucket_arn}/*"]
}

resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.provider_path}:sub" = local.service_account_sub
            "${local.provider_path}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(
    {
      Module = "irsa"
    },
    var.tags
  )
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.role_name}-s3"
  description = "Allow the application to interact with the S3 bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:HeadObject", "s3:ListBucket"]
        Resource = local.bucket_resources
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_access.arn
}
