locals {
  project = "unleash-home-exercise-tm"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = local.project
      Environment = terraform.workspace
      ManagedBy   = "terraform"
    }
  }
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_kms_key" "terraform_state_bucket" {
  description             = "KMS key for encrypting Terraform state bucket (${local.project})"
  deletion_window_in_days = 7
}

module "terraform_state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.2.1"

  bucket = "${local.project}-tf-state-${random_pet.this.id}"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.terraform_state_bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "terraform_locks" {
  description = "KMS key for encrypting Terraform lock table (${local.project})"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${local.project}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.terraform_locks.arn
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

output "backend_config_file" {
  value = {
    region         = var.region
    bucket         = module.terraform_state_bucket.s3_bucket_id
    key            = "${local.project}-terraform.tfstate"
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
  }
}
