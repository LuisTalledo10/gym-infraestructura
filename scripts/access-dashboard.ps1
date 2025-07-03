# Script PowerShell para acceder al CloudWatch Dashboard del Gym Management System
# Autor: Sistema automatizado  
# Fecha: 30 de junio de 2025

Write-Host "🏋️ Sistema de Gestión de Gimnasio - AWS Infrastructure" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""

# Configuración
$DashboardName = "gym-infrastructure-dashboard"
$Region = "us-east-1"
$ConsoleUrl = "https://console.aws.amazon.com/cloudwatch/home?region=$Region#dashboards:name=$DashboardName"

Write-Host "📊 Dashboard de Monitoreo:" -ForegroundColor Yellow
Write-Host "Nombre: $DashboardName"
Write-Host "Región: $Region"
Write-Host ""

Write-Host "🔗 URLs de Acceso:" -ForegroundColor Yellow
Write-Host "Dashboard Web: $ConsoleUrl"
Write-Host ""

Write-Host "💻 Comandos AWS CLI:" -ForegroundColor Yellow
Write-Host "Ver Dashboard: aws cloudwatch get-dashboard --dashboard-name $DashboardName --region $Region"
Write-Host "Listar Alarmas: aws cloudwatch describe-alarms --region $Region"
Write-Host "Ver Métricas Lambda: aws cloudwatch get-metric-statistics --namespace AWS/Lambda --region $Region"
Write-Host ""

Write-Host "📈 Recursos Monitoreados:" -ForegroundColor Yellow
Write-Host "✅ 3 Lambda Functions (user, booking, payment)" -ForegroundColor Green
Write-Host "✅ 1 RDS Instance (MySQL 8.0)" -ForegroundColor Green  
Write-Host "✅ 1 API Gateway" -ForegroundColor Green
Write-Host "✅ 1 S3 Bucket" -ForegroundColor Green
Write-Host "✅ 9 CloudWatch Alarms" -ForegroundColor Green
Write-Host "✅ 3 Log Groups" -ForegroundColor Green
Write-Host ""

Write-Host "🎯 Para acceder al dashboard:" -ForegroundColor Cyan
Write-Host "1. Abre tu navegador"
Write-Host "2. Ve a: $ConsoleUrl"
Write-Host "3. O ejecuta: aws cloudwatch get-dashboard --dashboard-name $DashboardName --region $Region"
Write-Host ""

Write-Host "🚀 ¡Infraestructura lista y monitoreada!" -ForegroundColor Green

# Abrir automáticamente el dashboard en el navegador (opcional)
# Start-Process $ConsoleUrl
