# CloudFront distribution for gym application
resource "aws_cloudfront_distribution" "gym_distribution" {
  origin {
    domain_name              = var.api_gateway_domain_name
    origin_id                = "APIGateway"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Origin for S3 static content (optional)
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "S3-gym-static-content"
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for Gym Management System"
  default_root_object = "index.html"

  # Cache behavior for API Gateway
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "APIGateway"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Authorization", "Content-Type"]
      
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Cache behavior for static content
  ordered_cache_behavior {
    path_pattern           = "/static/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-gym-static-content"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "gym-cloudfront"
    Environment = var.environment
    Project     = "gym-management"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Origin Access Identity for S3
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for gym static content"
}

# CloudWatch Logging
resource "aws_cloudfront_monitoring_subscription" "gym_monitoring" {
  distribution_id = aws_cloudfront_distribution.gym_distribution.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}

# Custom headers for security
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name    = "gym-security-headers"
  comment = "Security headers for gym application"

  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
    }
  }
}
