
# 🏋️ Sistema de Gestión de Gimnasio - AWS Infrastructure

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-Infrastructure-blue)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 📋 Descripción del Proyecto

Sistema completo de gestión de gimnasio desplegado en AWS usando infraestructura como código (Terraform). Incluye arquitectura serverless, base de datos, almacenamiento, API Gateway y monitoreo completo.

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS CLOUD                           │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │             │  │             │  │             │        │
│  │ API Gateway │──│   Lambda    │──│     RDS     │        │
│  │             │  │ Functions   │  │   MySQL     │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│         │                                   │              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │     S3      │  │     VPC     │  │ CloudWatch  │        │
│  │   Storage   │  │  Networking │  │ Monitoring  │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

### Componentes principales:
- **VPC y Networking**: Subredes públicas y privadas en múltiples AZs
- **RDS MySQL**: Base de datos con clase de instancia db.t3.micro compatible con MySQL 8.0
- **S3**: Almacenamiento de archivos con acceso público bloqueado  
- **API Gateway**: Endpoints REST para la aplicación
- **Lambda**: 3 funciones serverless (usuarios, reservas, pagos)
- **IAM**: Roles y políticas de seguridad
- **CloudWatch**: Dashboard de monitoreo y 9 alarmas configuradas

## 🚀 Descripción
Infraestructura como código para sistema de gestión de gimnasio usando AWS.

## 📋 Requisitos
- Terraform >= 1.11.4
- AWS CLI configurado
- Docker para análisis de seguridad
- Go para pruebas

## 🛠️ Uso
1. Inicializar Terraform:
```bash
terraform init
```

2. Planificar despliegue:
```bash
terraform plan
```

3. Aplicar infraestructura:
```bash
terraform apply -auto-approve
```

4. Ver outputs:
```bash
terraform output
```

## 📊 Dashboard de Monitoreo
URL: https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#dashboards:name=gym-infrastructure-dashboard

## 🎯 Outputs Principales
- `api_url`: ARN del API Gateway
- `lambda_function_arn`: ARN de las funciones Lambda  
- `rds_endpoint`: Endpoint de la base de datos MySQL
- `s3_bucket_name`: Nombre del bucket S3
- `vpc_id`: ID de la VPC

## ✅ Estado del Proyecto
**PRODUCTION READY** - Infraestructura desplegada y funcionando correctamente
```bash
go test ./tests/... -v
```

3. Análisis de seguridad:
```bash
./scripts/security_scan.sh
```

4. Desplegar:
```bash
terraform apply
```

## Monitoreo
Accede al dashboard de CloudWatch para métricas en tiempo real.

## Seguridad
- Análisis automático con Checkov
- Pruebas de seguridad en pipeline
- IAM con principio de mínimo privilegio