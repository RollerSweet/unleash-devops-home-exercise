variable "bucket_name" {
  description = "Name for the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow force destroying the bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the bucket."
  type        = map(string)
  default     = {}
}
