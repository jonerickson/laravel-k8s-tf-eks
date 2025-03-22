output "public_bucket_name" {
  description = "The name of the public S3 bucket."
  value       = module.s3[0].s3_bucket_id
}

output "private_bucket_name" {
  description = "The name of the private S3 bucket."
  value       = module.s3[1].s3_bucket_id
}