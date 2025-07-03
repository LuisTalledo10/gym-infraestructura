#!/bin/bash

# Script para mostrar las URLs importantes después del despliegue
# Ejecutar desde el directorio raíz del proyecto

echo "=========================================="
echo "🏋️  GYM MANAGEMENT SYSTEM - URLs"
echo "=========================================="
echo ""

# Verificar si Terraform está inicializado
if [ ! -f "terraform.tfstate" ]; then
    echo "❌ Error: No se encontró terraform.tfstate"
    echo "   Ejecuta 'terraform apply' primero"
    exit 1
fi

echo "📋 Obteniendo información de la infraestructura..."
echo ""

# Obtener outputs de Terraform
CLOUDFRONT_URL=$(terraform output -raw gym_application_url 2>/dev/null)
API_URL=$(terraform output -raw gym_api_url 2>/dev/null)
AUTH_URL=$(terraform output -raw gym_auth_url 2>/dev/null)
COGNITO_POOL_ID=$(terraform output -raw cognito_user_pool_id 2>/dev/null)
COGNITO_CLIENT_ID=$(terraform output -raw cognito_user_pool_client_id 2>/dev/null)
CLOUDFRONT_DOMAIN=$(terraform output -raw cloudfront_domain_name 2>/dev/null)

echo "🌐 URLs PRINCIPALES:"
echo "────────────────────────────────────────"
if [ ! -z "$CLOUDFRONT_URL" ]; then
    echo "🎯 Aplicación Web:    $CLOUDFRONT_URL"
else
    echo "🎯 Aplicación Web:    [No disponible]"
fi

if [ ! -z "$API_URL" ]; then
    echo "🔌 API REST:          $API_URL"
else
    echo "🔌 API REST:          [No disponible]"
fi

if [ ! -z "$AUTH_URL" ]; then
    echo "🔐 Autenticación:     $AUTH_URL"
else
    echo "🔐 Autenticación:     [No disponible]"
fi

echo ""
echo "⚙️  CONFIGURACIÓN COGNITO:"
echo "────────────────────────────────────────"
if [ ! -z "$COGNITO_POOL_ID" ]; then
    echo "🆔 User Pool ID:      $COGNITO_POOL_ID"
else
    echo "🆔 User Pool ID:      [No disponible]"
fi

if [ ! -z "$COGNITO_CLIENT_ID" ]; then
    echo "🔑 Client ID:         $COGNITO_CLIENT_ID"
else
    echo "🔑 Client ID:         [No disponible]"
fi

echo ""
echo "📊 MONITOREO:"
echo "────────────────────────────────────────"
echo "📈 CloudWatch:        https://console.aws.amazon.com/cloudwatch/home?region=$(terraform output -raw region 2>/dev/null || echo 'us-east-1')#dashboards:name=gym-monitoring-dashboard"
echo ""

echo "👥 GRUPOS DE USUARIOS:"
echo "────────────────────────────────────────"
echo "👑 Administradores:   gym-admins"
echo "🏃 Entrenadores:      gym-trainers"  
echo "💪 Miembros:          gym-members"
echo ""

echo "🚀 COMANDOS ÚTILES:"
echo "────────────────────────────────────────"
echo "📊 Ver dashboard:     ./scripts/access-dashboard.sh"
echo "📖 Ver documentación: ./scripts/show-documentation.sh"
echo "🔄 Actualizar infra:  terraform apply"
echo "💥 Destruir infra:    terraform destroy"
echo ""

# Mostrar configuración completa de Cognito para desarrolladores
echo "👨‍💻 CONFIGURACIÓN PARA DESARROLLADORES:"
echo "────────────────────────────────────────"
echo "Para integrar la autenticación en tu aplicación frontend:"
echo ""
echo "const awsConfig = {"
echo "  region: '$(terraform output -raw region 2>/dev/null || echo 'us-east-1')',"
if [ ! -z "$COGNITO_POOL_ID" ]; then
    echo "  userPoolId: '$COGNITO_POOL_ID',"
fi
if [ ! -z "$COGNITO_CLIENT_ID" ]; then
    echo "  userPoolWebClientId: '$COGNITO_CLIENT_ID',"
fi
if [ ! -z "$CLOUDFRONT_DOMAIN" ]; then
    echo "  authDomain: 'gym-auth-xxx.auth.$(terraform output -raw region 2>/dev/null || echo 'us-east-1').amazoncognito.com',"
    echo "  redirectSignIn: 'https://$CLOUDFRONT_DOMAIN/callback',"
    echo "  redirectSignOut: 'https://$CLOUDFRONT_DOMAIN/logout'"
fi
echo "};"
echo ""

echo "✅ Infraestructura desplegada correctamente!"
echo "📚 Consulta docs/ para más información."
echo "=========================================="
