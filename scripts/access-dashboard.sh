#!/bin/bash

# Script para acceder al CloudWatch Dashboard del Gym Management System
# Autor: Sistema automatizado
# Fecha: 30 de junio de 2025

echo "🏋️ Sistema de Gestión de Gimnasio - AWS Infrastructure"
echo "=================================================="
echo ""

# Configuración
DASHBOARD_NAME="gym-infrastructure-dashboard"
REGION="us-east-1"
CONSOLE_URL="https://console.aws.amazon.com/cloudwatch/home?region=${REGION}#dashboards:name=${DASHBOARD_NAME}"

echo "📊 Dashboard de Monitoreo:"
echo "Nombre: ${DASHBOARD_NAME}"
echo "Región: ${REGION}"
echo ""

echo "🔗 URLs de Acceso:"
echo "Dashboard Web: ${CONSOLE_URL}"
echo ""

echo "💻 Comandos AWS CLI:"
echo "Ver Dashboard: aws cloudwatch get-dashboard --dashboard-name ${DASHBOARD_NAME} --region ${REGION}"
echo "Listar Alarmas: aws cloudwatch describe-alarms --region ${REGION}"
echo "Ver Métricas Lambda: aws cloudwatch get-metric-statistics --namespace AWS/Lambda --region ${REGION}"
echo ""

echo "📈 Recursos Monitoreados:"
echo "✅ 3 Lambda Functions (user, booking, payment)"
echo "✅ 1 RDS Instance (MySQL 8.0)"
echo "✅ 1 API Gateway"
echo "✅ 1 S3 Bucket"
echo "✅ 9 CloudWatch Alarms"
echo "✅ 3 Log Groups"
echo ""

echo "🎯 Para acceder al dashboard:"
echo "1. Abre tu navegador"
echo "2. Ve a: ${CONSOLE_URL}"
echo "3. O ejecuta: aws cloudwatch get-dashboard --dashboard-name ${DASHBOARD_NAME} --region ${REGION}"
echo ""

echo "🚀 ¡Infraestructura lista y monitoreada!"
