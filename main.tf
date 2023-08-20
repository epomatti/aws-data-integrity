terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  project_name = "dataintegritysandbox"

  important_key = "important.txt"
  artifacts_dir = "./artifacts"
}

### S3 ###
resource "aws_s3_bucket" "main" {
  bucket = "bucket${local.project_name}789"

  # Object Lock must be enabled on creation.
  # This also requires Versioning and S3 will automatically enable it.
  object_lock_enabled = true

  # For development purposes
  force_destroy = true
}

resource "aws_s3_object" "important" {
  bucket = aws_s3_bucket.main.id
  key    = "important.txt"
  source = "./artifacts/important-v1.txt"
  etag   = filemd5("./artifacts/important-v1.txt")
}
