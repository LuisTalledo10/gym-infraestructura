# CloudWatch Dashboard para monitoreo de infraestructura
resource "aws_cloudwatch_dashboard" "gym_infrastructure" {
  dashboard_name = "gym-infrastructure-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_user_function_name],
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_booking_function_name],
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_payment_function_name],
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_user_function_name],
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_booking_function_name],
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_payment_function_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Lambda Functions - Invocations & Errors"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_user_function_name],
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_booking_function_name],
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_payment_function_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Lambda Functions - Duration"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_identifier],
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_identifier],
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", var.rds_instance_identifier]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "RDS Performance Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiName", var.api_gateway_name],
            ["AWS/ApiGateway", "Latency", "ApiName", var.api_gateway_name],
            ["AWS/ApiGateway", "4XXError", "ApiName", var.api_gateway_name],
            ["AWS/ApiGateway", "5XXError", "ApiName", var.api_gateway_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "API Gateway Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 8
        height = 6

        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", "BucketName", var.s3_bucket_name, "StorageType", "StandardStorage"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "S3 Bucket Size"
          period  = 86400
        }
      },
      {
        type   = "log"
        x      = 8
        y      = 12
        width  = 16
        height = 6

        properties = {
          query   = "SOURCE '/aws/lambda/${var.lambda_user_function_name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region  = var.region
          title   = "Recent Lambda Logs"
        }
      }
    ]
  })
}

# CloudWatch Alarms para alertas automáticas
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  for_each = toset([
    var.lambda_user_function_name,
    var.lambda_booking_function_name,
    var.lambda_payment_function_name
  ])

  alarm_name          = "${each.value}-high-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors for ${each.value}"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    FunctionName = each.value
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_errors" {
  alarm_name          = "api-gateway-high-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors API Gateway 5XX errors"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    ApiName = var.api_gateway_name
  }
}

# Log Groups para mejor organización
resource "aws_cloudwatch_log_group" "lambda_logs" {
  for_each = toset([
    var.lambda_user_function_name,
    var.lambda_booking_function_name,
    var.lambda_payment_function_name
  ])

  name              = "/aws/lambda/${each.value}"
  retention_in_days = 14
}
