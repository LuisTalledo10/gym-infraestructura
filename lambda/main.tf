# Lambda para gestión de usuarios
resource "aws_lambda_function" "user_management" {
  function_name = "gym-user-management"
  role          = aws_iam_role.lambda_role.arn
  handler       = "user.handler"
  runtime       = "nodejs18.x"
  
  # Usar archivo local temporalmente
  filename      = "${path.module}/user-function.zip"
  
  depends_on = [data.archive_file.user_zip]

  # Solo agregar VPC config si se proporciona VPC ID
  dynamic "vpc_config" {
    for_each = var.vpc_id != "" ? [1] : []
    content {
      subnet_ids         = var.private_subnet_ids
      security_group_ids = var.vpc_id != "" ? [aws_security_group.lambda_sg.id] : []
    }
  }

  environment {
    variables = {
      DB_HOST = var.db_endpoint
      S3_BUCKET = var.s3_bucket_name
    }
  }
}

# Crear ZIP para función de usuarios
data "archive_file" "user_zip" {
  type        = "zip"
  source_file = "${path.module}/user.js"
  output_path = "${path.module}/user-function.zip"
}

# Lambda para sistema de reservas
resource "aws_lambda_function" "booking_system" {
  function_name = "gym-booking-system"
  role          = aws_iam_role.lambda_role.arn
  handler       = "booking.handler"
  runtime       = "nodejs18.x"
  
  filename      = "${path.module}/booking-function.zip"
  depends_on = [data.archive_file.booking_zip]

  # Solo agregar VPC config si se proporciona VPC ID
  dynamic "vpc_config" {
    for_each = var.vpc_id != "" ? [1] : []
    content {
      subnet_ids         = var.private_subnet_ids
      security_group_ids = var.vpc_id != "" ? [aws_security_group.lambda_sg.id] : []
    }
  }

  environment {
    variables = {
      DB_HOST = var.db_endpoint
      S3_BUCKET = var.s3_bucket_name
    }
  }
}

# Crear ZIP para función de reservas
data "archive_file" "booking_zip" {
  type        = "zip"
  source_file = "${path.module}/booking.js"
  output_path = "${path.module}/booking-function.zip"
}

# Lambda para procesamiento de pagos
resource "aws_lambda_function" "payment_processor" {
  function_name = "gym-payment-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "payment.handler"
  runtime       = "nodejs18.x"
  
  filename      = "${path.module}/payment-function.zip"
  depends_on = [data.archive_file.payment_zip]

  # Solo agregar VPC config si se proporciona VPC ID
  dynamic "vpc_config" {
    for_each = var.vpc_id != "" ? [1] : []
    content {
      subnet_ids         = var.private_subnet_ids
      security_group_ids = var.vpc_id != "" ? [aws_security_group.lambda_sg.id] : []
    }
  }

  environment {
    variables = {
      DB_HOST = var.db_endpoint
      STRIPE_KEY = var.stripe_secret_key
    }
  }
}

# Crear ZIP para función de pagos
data "archive_file" "payment_zip" {
  type        = "zip"
  source_file = "${path.module}/payment.js"
  output_path = "${path.module}/payment-function.zip"
}

# Security Group para Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Security group for Lambda functions"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "gym-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# Agregar política AWS administrada para VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "gym-lambda-policy"
  description = "Lambda policy with basic permissions and VPC access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

