# Script de Instalação do Módulo de IA para Orçamentos
# Hospitalar Saúde - Manus AI
# Versão 1.0.0

param(
    [string]$LaravelPath = "C:\Users\rudpa\Documents\hospitalar\hospitalar_v2\hospitalar_backend"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  INSTALAÇÃO DO MÓDULO DE IA - ORÇAMENTOS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o caminho do Laravel existe
if (-not (Test-Path $LaravelPath)) {
    Write-Host "ERRO: Caminho do Laravel não encontrado: $LaravelPath" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Laravel encontrado em: $LaravelPath" -ForegroundColor Green

# Criar diretórios
Write-Host ""
Write-Host "1. CRIANDO DIRETÓRIOS..." -ForegroundColor Yellow
$controllerPath = Join-Path $LaravelPath "app\Http\Controllers\IA"
$servicePath = Join-Path $LaravelPath "app\Services\IA"
$configPath = Join-Path $LaravelPath "config"

New-Item -ItemType Directory -Force -Path $controllerPath | Out-Null
New-Item -ItemType Directory -Force -Path $servicePath | Out-Null
Write-Host "   ✅ Diretórios criados" -ForegroundColor Green

# Baixar arquivos do GitHub
Write-Host ""
Write-Host "2. BAIXANDO ARQUIVOS DO GITHUB..." -ForegroundColor Yellow
$baseUrl = "https://raw.githubusercontent.com/Rudson-Oliveira/projeto-2026-autonomia/master/laravel-ia-module"

$files = @{
    "IAOrcamentoController.php" = "$controllerPath\IAOrcamentoController.php"
    "IAOrcamentoService.php" = "$servicePath\IAOrcamentoService.php"
    "IAServiceProvider.php" = "$LaravelPath\app\Providers\IAServiceProvider.php"
    "ia_routes.php" = "$LaravelPath\routes\ia_routes.php"
    "config_ia.php" = "$configPath\ia.php"
}

foreach ($file in $files.GetEnumerator()) {
    $url = "$baseUrl/$($file.Key)"
    $dest = $file.Value
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "   ✅ $($file.Key)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Erro ao baixar $($file.Key): $_" -ForegroundColor Red
    }
}

# Adicionar variáveis de ambiente ao .env
Write-Host ""
Write-Host "3. CONFIGURANDO VARIÁVEIS DE AMBIENTE..." -ForegroundColor Yellow
$envPath = Join-Path $LaravelPath ".env"
$envAdditions = @"

# IA Module - Manus AI
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2
OLLAMA_TIMEOUT=30
HUB_CENTRAL_URL=http://localhost:5002
COMET_BRIDGE_URL=http://localhost:5000
COMET_BRIDGE_NGROK_URL=https://manus-comet-hospital.ngrok-free.dev
VISION_AI_URL=https://visionai-khprjuve.manus.space
VISION_AI_ENABLED=true
BUDGET_DEFAULT_MARGIN=20
IA_CACHE_ENABLED=true
IA_LOGGING_ENABLED=true
"@

if (Test-Path $envPath) {
    $envContent = Get-Content $envPath -Raw
    if (-not $envContent.Contains("IA Module")) {
        Add-Content -Path $envPath -Value $envAdditions
        Write-Host "   ✅ Variáveis adicionadas ao .env" -ForegroundColor Green
    } else {
        Write-Host "   ⏭️ Variáveis já existem no .env" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️ Arquivo .env não encontrado" -ForegroundColor Yellow
}

# Instruções finais
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PRÓXIMOS PASSOS MANUAIS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Adicionar ao config/app.php em 'providers':" -ForegroundColor White
Write-Host "   App\Providers\IAServiceProvider::class," -ForegroundColor Gray
Write-Host ""
Write-Host "2. Adicionar ao routes/api.php:" -ForegroundColor White
Write-Host "   require __DIR__ . '/ia_routes.php';" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Executar no terminal:" -ForegroundColor White
Write-Host "   docker exec -it hospitalar_php php artisan config:clear" -ForegroundColor Gray
Write-Host "   docker exec -it hospitalar_php php artisan route:clear" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Testar:" -ForegroundColor White
Write-Host "   curl http://localhost:8888/api/ia/health" -ForegroundColor Gray
Write-Host ""
Write-Host "Documentação: https://github.com/Rudson-Oliveira/projeto-2026-autonomia/tree/master/laravel-ia-module" -ForegroundColor Cyan
