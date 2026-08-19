resource "aws_iam_role" "backup_role" {
    name = "AWS_Backup-Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "backup.amazonaws.com"
                }
            }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "backup_service_role_policy" {
    role       = aws_iam_role.backup_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

#AWS Backup Vault and Plan for Daily Backups
resource "aws_backup_vault" "daily_backup_vault" {
    name        = "daily-backup-vault"
    tags = {
        Environment = "Production"
    }
}

#AWS Backup Plan for Daily Backups
resource "aws_backup_plan" "daily_backup_plan" {
    name = "daily-backup-plan"
    rule {
        rule_name         = "daily-backup-rule"
        target_vault_name = aws_backup_vault.daily_backup_vault.name
        schedule          = "cron(0 12 * * ? *)" # Daily at 12:00 PM UTC
        lifecycle {
            delete_after = var.backup_retention_days # Retain backups for the specified number of days
        }
    }
}

#AWS Backup Selection for Daily Backups
resource "aws_backup_selection" "daily_backup_selection" {
    name          = "daily-backup-selection"
    iam_role_arn  = aws_iam_role.backup_role.arn
    backup_plan_id = aws_backup_plan.daily_backup_plan.id

    resources = [
        "arn:aws:ec2:*:*:instance/*"
    ]
}
