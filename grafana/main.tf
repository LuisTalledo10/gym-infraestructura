# Amazon Managed Grafana for Gym Infrastructure Monitoring
resource "aws_grafana_workspace" "gym_grafana" {
  name                     = var.workspace_name
  description              = "Grafana workspace for gym infrastructure monitoring"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["SAML"]  # SAML sin configuración compleja
  permission_type          = "SERVICE_MANAGED"  # Cambiar a service managed (más simple)
  
  data_sources = [
    "CLOUDWATCH",
    "PROMETHEUS",
    "XRAY"
  ]

  notification_destinations = ["SNS"]

  # Sin configuración adicional para evitar errores
  # configuration = jsonencode({})  # Comentado

  tags = {
    Name        = "gym-grafana-workspace"
    Environment = var.environment
    Project     = "gym-management"
  }
}

# IAM Role for Grafana to access AWS services
resource "aws_iam_role" "grafana_access" {
  name = "gym-grafana-access-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "grafana.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  tags = {
    Name        = "gym-grafana-role"
    Environment = var.environment
    Project     = "gym-management"
  }
}

# CloudWatch read-only access for metrics
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch" {
  role       = aws_iam_role.grafana_access.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# X-Ray read access for tracing
resource "aws_iam_role_policy_attachment" "grafana_xray" {
  role       = aws_iam_role.grafana_access.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"
}

# SNS access for notifications
resource "aws_iam_role_policy_attachment" "grafana_sns" {
  role       = aws_iam_role.grafana_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}

# Custom policy for additional AWS services
resource "aws_iam_role_policy" "grafana_custom_policy" {
  name = "gym-grafana-custom-policy"
  role = aws_iam_role.grafana_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults",
          "logs:GetLogRecord",
          "ec2:DescribeRegions",
          "ec2:DescribeInstances",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "lambda:ListFunctions",
          "lambda:GetFunction",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "apigateway:GET",
          "iam:ListRoles",
          "iam:ListAttachedRolePolicies",
          "iam:GetRole"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:ListTopics",
          "sns:ListSubscriptionsByTopic",
          "sns:GetTopicAttributes"
        ]
        Resource = var.sns_topic_arn != "" ? var.sns_topic_arn : "*"
      }
    ]
  })
}

# Grafana License Association (if using Enterprise features)
resource "aws_grafana_license_association" "gym_grafana_license" {
  count        = var.enable_enterprise_features ? 1 : 0
  license_type = "ENTERPRISE"
  workspace_id = aws_grafana_workspace.gym_grafana.id
}

# Data sources for getting current AWS account info
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Create CloudWatch dashboard templates for Grafana
resource "aws_cloudwatch_dashboard" "grafana_integration" {
  dashboard_name = "gym-grafana-integration"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 3

        properties = {
          markdown = "# Gym Infrastructure - Grafana Integration\n\nThis dashboard shows integration status between CloudWatch and Grafana.\n\n**Grafana Workspace**: ${aws_grafana_workspace.gym_grafana.endpoint}"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "gym-user-management"],
            ["AWS/Lambda", "Invocations", "FunctionName", "gym-booking-system"],
            ["AWS/Lambda", "Invocations", "FunctionName", "gym-payment-processor"]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "Lambda Invocations (Available in Grafana)"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_identifier]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "RDS CPU (Available in Grafana)"
        }
      }
    ]
  })
}

# CloudWatch Log Group for Grafana logs
resource "aws_cloudwatch_log_group" "grafana_logs" {
  name              = "/aws/grafana/${aws_grafana_workspace.gym_grafana.id}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "gym-grafana-logs"
    Environment = var.environment
    Project     = "gym-management"
  }
}
