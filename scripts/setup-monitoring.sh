#!/bin/bash

echo "🔍 Configurando monitoreo de infraestructura..."

# Aplicar cambios de Terraform
echo "Desplegando recursos de monitoreo..."
terraform init
terraform plan -target=module.monitoring
terraform apply -target=module.monitoring -auto-approve

# Obtener URL del dashboard
DASHBOARD_URL=$(terraform output -raw monitoring_dashboard_url 2>/dev/null || echo "Dashboard URL no disponible aún")

echo "✅ Monitoreo configurado exitosamente!"
echo ""
echo "📊 DASHBOARD DE MONITOREO:"
echo "URL: $DASHBOARD_URL"
echo ""
echo "📈 MÉTRICAS DISPONIBLES:"
echo "- Lambda Functions: Invocaciones, errores, duración"
echo "- RDS Database: CPU, conexiones, memoria"
echo "- API Gateway: Requests, latencia, errores"
echo "- S3 Bucket: Tamaño de almacenamiento"
echo "- Logs: Últimos 20 logs de Lambda"
echo ""
echo "🚨 ALERTAS CONFIGURADAS:"
echo "- Lambda errors > 5 en 10 minutos"
echo "- RDS CPU > 80% por 10 minutos"
echo "- API Gateway 5XX errors > 10 en 10 minutos"
echo ""
echo "📱 Para acceder al dashboard:"
echo "1. Ve a AWS Console > CloudWatch > Dashboards"
echo "2. Busca 'gym-infrastructure-dashboard'"
echo "3. O usa la URL proporcionada arriba"
