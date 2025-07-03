resource "aws_iam_role" "admin_role" {
  name = "gym-admin-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "admin_policy" {
  name        = "gym-admin-policy"
  description = "Admin policy for full access to all resources"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  policy_arn = aws_iam_policy.admin_policy.arn
  role       = aws_iam_role.admin_role.name
}

# SNS Topic para alertas
resource "aws_sns_topic" "gym_alerts" {
  name = "gym-infrastructure-alerts"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.gym_alerts.arn
  protocol  = "email"
  endpoint  = "admin@gym.com"  # Cambiar por tu email real
}
