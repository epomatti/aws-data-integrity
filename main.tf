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

### Variables ###

locals {
  count_s3      = var.toggle_create_s3 ? 1 : 0
  count_glacier = var.toggle_create_glacier ? 1 : 0
}

### Modules

module "s3_bucket" {
  source = "./modules/s3"
  count  = local.count_s3
}

module "glacier" {
  source = "./modules/glacier"
  count  = local.count_glacier

  lockpolicy_ArchiveAgeInDays = var.glacier_lockpolicy_ArchiveAgeInDays
}
