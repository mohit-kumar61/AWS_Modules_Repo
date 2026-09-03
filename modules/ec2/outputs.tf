output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.ec2[0].id
}

output "instance_ids" {
  description = "IDs of the EC2 instances."
  value       = aws_instance.ec2[*].id
}

output "key_name" {
  description = "Name of the generated EC2 key pair."
  value       = aws_key_pair.ec2.key_name
}

output "private_key_s3_uri" {
  description = "S3 URI containing the generated private key."
  value       = "s3://${aws_s3_bucket.keypair.bucket}/${aws_s3_object.private_key.key}"
}