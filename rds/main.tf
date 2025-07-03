resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for the RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "gym-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "gym-db-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage       = 20
  instance_class          = "db.t3.micro"   # Compatible con MySQL 8.0
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = var.db_username
  password                = var.db_password
  db_name                 = "gymdb"
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  multi_az                = false
  storage_type            = "gp2"
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Name = "gym-db-instance"
  }
}