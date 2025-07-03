output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.gym_distribution.id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.gym_distribution.arn
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.gym_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.gym_distribution.hosted_zone_id
}

output "cloudfront_status" {
  description = "Status of the CloudFront distribution"
  value       = aws_cloudfront_distribution.gym_distribution.status
}

output "origin_access_identity_id" {
  description = "ID of the Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.oai.id
}

output "origin_access_identity_iam_arn" {
  description = "IAM ARN of the Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}
