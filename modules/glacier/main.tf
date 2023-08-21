data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

resource "aws_glacier_vault" "main" {
  name = "dataintegritysandboxglacier789"  
}

resource "aws_glacier_vault_lock" "example" {
  vault_name = aws_glacier_vault.main.name

  # Set to automatically expire after 24h
  complete_lock = false

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "deny-based-on-archive-age",
          "Principal" : "*",
          "Effect" : "Deny",
          "Action" : "glacier:DeleteArchive",
          "Resource" : [
            "arn:aws:glacier:${local.region}:${local.account_id}:vaults/${aws_glacier_vault.main.name}"
          ],
          "Condition" : {
            "NumericLessThan" : {
              "glacier:ArchiveAgeInDays" : "${var.lockpolicy_ArchiveAgeInDays}"
            }
          }
        }
      ]
    }
  )
}
