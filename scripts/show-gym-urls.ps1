# Script para mostrar las URLs importantes después del despliegue
# Ejecutar desde el directorio raíz del proyecto

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🏋️  GYM MANAGEMENT SYSTEM - URLs" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Terraform está inicializado
if (!(Test-Path "terraform.tfstate")) {
    Write-Host "❌ Error: No se encontró terraform.tfstate" -ForegroundColor Red
    Write-Host "   Ejecuta 'terraform apply' primero" -ForegroundColor Yellow
    exit 1
}

Write-Host "📋 Obteniendo información de la infraestructura..." -ForegroundColor Green
Write-Host ""

# Obtener outputs de Terraform
try {
    $CLOUDFRONT_URL = terraform output -raw gym_application_url 2>$null
    $API_URL = terraform output -raw gym_api_url 2>$null
    $AUTH_URL = terraform output -raw gym_auth_url 2>$null
    $COGNITO_POOL_ID = terraform output -raw cognito_user_pool_id 2>$null
    $COGNITO_CLIENT_ID = terraform output -raw cognito_user_pool_client_id 2>$null
    $CLOUDFRONT_DOMAIN = terraform output -raw cloudfront_domain_name 2>$null
    $REGION = terraform output -raw region 2>$null
    if (!$REGION) { $REGION = "us-east-1" }
}
catch {
    Write-Host "⚠️  Algunos outputs no están disponibles" -ForegroundColor Yellow
}

Write-Host "🌐 URLs PRINCIPALES:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
if ($CLOUDFRONT_URL) {
    Write-Host "🎯 Aplicación Web:    $CLOUDFRONT_URL" -ForegroundColor Green
} else {
    Write-Host "🎯 Aplicación Web:    [No disponible]" -ForegroundColor Gray
}

if ($API_URL) {
    Write-Host "🔌 API REST:          $API_URL" -ForegroundColor Green
} else {
    Write-Host "🔌 API REST:          [No disponible]" -ForegroundColor Gray
}

if ($AUTH_URL) {
    Write-Host "🔐 Autenticación:     $AUTH_URL" -ForegroundColor Green
} else {
    Write-Host "🔐 Autenticación:     [No disponible]" -ForegroundColor Gray
}

Write-Host ""
Write-Host "⚙️  CONFIGURACIÓN COGNITO:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
if ($COGNITO_POOL_ID) {
    Write-Host "🆔 User Pool ID:      $COGNITO_POOL_ID" -ForegroundColor Green
} else {
    Write-Host "🆔 User Pool ID:      [No disponible]" -ForegroundColor Gray
}

if ($COGNITO_CLIENT_ID) {
    Write-Host "🔑 Client ID:         $COGNITO_CLIENT_ID" -ForegroundColor Green
} else {
    Write-Host "🔑 Client ID:         [No disponible]" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 MONITOREO:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
Write-Host "📈 CloudWatch:        https://console.aws.amazon.com/cloudwatch/home?region=$REGION#dashboards:name=gym-monitoring-dashboard" -ForegroundColor Green
Write-Host ""

Write-Host "👥 GRUPOS DE USUARIOS:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
Write-Host "👑 Administradores:   gym-admins" -ForegroundColor Magenta
Write-Host "🏃 Entrenadores:      gym-trainers" -ForegroundColor Yellow  
Write-Host "💪 Miembros:          gym-members" -ForegroundColor Blue
Write-Host ""

Write-Host "🚀 COMANDOS ÚTILES:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
Write-Host "📊 Ver dashboard:     .\scripts\access-dashboard.ps1" -ForegroundColor Green
Write-Host "📖 Ver documentación: .\scripts\show-documentation.ps1" -ForegroundColor Green
Write-Host "🔄 Actualizar infra:  terraform apply" -ForegroundColor Yellow
Write-Host "💥 Destruir infra:    terraform destroy" -ForegroundColor Red
Write-Host ""

# Mostrar configuración completa de Cognito para desarrolladores
Write-Host "👨‍💻 CONFIGURACIÓN PARA DESARROLLADORES:" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────"
Write-Host "Para integrar la autenticación en tu aplicación frontend:" -ForegroundColor White
Write-Host ""
Write-Host "const awsConfig = {" -ForegroundColor DarkGray
Write-Host "  region: '$REGION'," -ForegroundColor DarkGray
if ($COGNITO_POOL_ID) {
    Write-Host "  userPoolId: '$COGNITO_POOL_ID'," -ForegroundColor DarkGray
}
if ($COGNITO_CLIENT_ID) {
    Write-Host "  userPoolWebClientId: '$COGNITO_CLIENT_ID'," -ForegroundColor DarkGray
}
if ($CLOUDFRONT_DOMAIN) {
    Write-Host "  authDomain: 'gym-auth-xxx.auth.$REGION.amazoncognito.com'," -ForegroundColor DarkGray
    Write-Host "  redirectSignIn: 'https://$CLOUDFRONT_DOMAIN/callback'," -ForegroundColor DarkGray
    Write-Host "  redirectSignOut: 'https://$CLOUDFRONT_DOMAIN/logout'" -ForegroundColor DarkGray
}
Write-Host "};" -ForegroundColor DarkGray
Write-Host ""

Write-Host "✅ Infraestructura desplegada correctamente!" -ForegroundColor Green
Write-Host "📚 Consulta docs/ para más información." -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Cyan

# Pausa para que el usuario pueda leer
Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
