# BackupSetup

Terraform configuration for creating an AWS Backup setup for EC2 instances.

## What it creates

- An IAM role trusted by AWS Backup.
- The AWS-managed `AWSBackupServiceRolePolicyForBackup` policy attachment.
- A backup vault named `daily-backup-vault`, tagged with `Environment = Production`.
- A backup plan named `daily-backup-plan` with a daily schedule at 12:00 PM UTC.
- A backup selection that targets EC2 instances in the account.

Backups are retained for 14 days by default. The retention period can be changed with the `backup_retention_days` variable.

## Prerequisites

- Terraform 1.x.
- An AWS account with permissions to create IAM, AWS Backup, and EC2 backup resources.
- AWS credentials configured through the AWS CLI, environment variables, or another supported credential source.
- An existing S3 bucket named `mohit-kumar61-code-bucket` for the Terraform state backend.

## Configuration

The available input variables are:

| Variable | Description | Default |
| --- | --- | --- |
| `aws_region` | AWS region where resources are deployed | `us-east-1` |
| `backup_retention_days` | Number of days to retain backups | `14` |

Override values with a `.tfvars` file or command-line options, for example:

```hcl
aws_region           = "us-east-1"
backup_retention_days = 30
```

## Usage

Initialize Terraform, review the proposed changes, and apply them:

```bash
terraform init
terraform plan
terraform apply
```

To remove the resources managed by this configuration:

```bash
terraform destroy
```

The backup schedule uses the AWS Backup cron expression `cron(0 12 * * ? *)`, which runs daily at 12:00 PM UTC.

## State backend

Terraform stores state remotely in the `mohit-kumar61-code-bucket` S3 bucket under the key `terraform.tfstate`. The bucket must exist before running `terraform init`. Backend configuration is read during initialization, so provide the backend region during initialization if your Terraform version does not accept the configured region directly:

```bash
terraform init -backend-config="region=us-east-1"
```

## Files

- `Backup.tf` - IAM role, backup vault, backup plan, and EC2 backup selection.
- `provider.tf` - AWS provider requirements, provider configuration, and S3 state backend.
- `variable.tf` - Terraform input variables for the AWS region and retention period.