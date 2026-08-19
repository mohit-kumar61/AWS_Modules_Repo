# BackupSetup

Terraform configuration for setting up AWS backup infrastructure.

## Current status

The repository currently contains the AWS provider configuration and a variable for the deployment region. Backup resources have not yet been defined in `Backup.tf`.

## Prerequisites

- Terraform 1.x
- An AWS account
- AWS credentials configured through the AWS CLI, environment variables, or another supported credential source
- An existing S3 bucket named `mohit-kumar61-code-bucket` for the Terraform state backend

## Files

- `Backup.tf` - Backup resource definitions.
- `provider.tf` - AWS provider and S3 state backend configuration.
- `variable.tf` - Terraform input variables.

## State backend

Terraform state is stored remotely in the `mohit-kumar61-code-bucket` S3 bucket under `terraform.tfstate`.