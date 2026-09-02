variable "backup_schedule" {
  description = "Cron expression for the backup schedule."
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain backups."
  type        = number
}

variable "backup_tag_key" {
  description = "Tag key used to identify resources for backup."
  type        = string
}

variable "backup_tag_value" {
  description = "Tag value used to identify resources for backup."
  type        = string
}
