resource "aws_dynamodb_table" "customers" {
  name           = "Customers"
  billing_mode   = "PAY_PER_REQUEST"
  stream_enabled = false
  hash_key       = "id"

  deletion_protection_enabled = false

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_backup_vault" "main" {
  name          = "DynamoDBVault"
  force_destroy = true
}

resource "aws_backup_plan" "dynamodb" {
  name = "dynamodb-backup-plan"

  rule {
    rule_name         = "rule1"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "backup" {
  name               = "backup-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

resource "aws_backup_selection" "dynamodb" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "dynamodb-resource-selection"
  plan_id      = aws_backup_plan.dynamodb.id

  resources = [
    aws_dynamodb_table.customers.arn
  ]
}

resource "aws_backup_vault_lock_configuration" "temp" {
  backup_vault_name   = aws_backup_vault.main.name
  changeable_for_days = 3
  max_retention_days  = 7
  min_retention_days  = 1
}
