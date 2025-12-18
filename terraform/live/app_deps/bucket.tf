resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.env}-app-s3-bucket"
}

resource "aws_iam_policy" "app_s3_policy" {
  name        = "AppS3AccessPolicy"
  description = "Policy to allow application access to the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.env}-app-s3-bucket",
          "arn:aws:s3:::${var.env}-app-s3-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "app_iam_role" {
  name = "app-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks.outputs.oidc_provider}:sub" = "system:serviceaccount:unleash:unleash-home-exercise"
            "${data.terraform_remote_state.eks.outputs.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_s3_attach" {
  policy_arn = aws_iam_policy.app_s3_policy.arn
  role       = aws_iam_role.app_iam_role.name
}