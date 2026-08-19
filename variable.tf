variable "aws_region" {
    description = "The region where the resource will be deployed"
    type        = string
    default     = "us-east-1"
}

variable "backup_retention_days" {
    description = "Number of days to retain backups"
    type        = number
    default     = 14
}