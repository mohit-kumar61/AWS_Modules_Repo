# ---------------------------------------------------------------------------
#                             IAM role for AWS Backup
# ---------------------------------------------------------------------------

resource "aws_iam_role" "backup" {
  name_prefix = "AWS_Backup-Role"
  description = "Role for AWS Backup"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

# ---------------------------------------------------------------------------
#                                 Backup Vault
# ---------------------------------------------------------------------------

resource "aws_backup_vault" "main" {
  name        = "AWS-Daily-Backup-Vault"
  force_destroy = true
}

# ---------------------------------------------------------------------------
#                                 Backup Plan
# ---------------------------------------------------------------------------

resource "aws_backup_plan" "main" {
  name = "AWS-Daily-Backup-Plan"

  rule {
    rule_name       = "daily_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule        = var.backup_schedule

    lifecycle {
      delete_after = var.retention_days
    }
  }
  depends_on = [aws_backup_vault.main]
}

# ---------------------------------------------------------------------------
#                                 Backup Selection
# ---------------------------------------------------------------------------

resource "aws_backup_selection" "by_tag" {
  name         = "AWS-Daily-Backup-Selection"
  plan_id      = aws_backup_plan.main.id
  iam_role_arn = aws_iam_role.backup.arn

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.backup_tag_key
    value = var.backup_tag_value
  }
}
