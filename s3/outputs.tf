output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = "http://${aws_s3_bucket.bucket.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

# Data source for current AWS region
data "aws_region" "current" {}
