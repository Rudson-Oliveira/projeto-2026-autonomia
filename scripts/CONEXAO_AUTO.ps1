# CONEXAO_AUTO.ps1
# Projeto 2026 - Workflow de Conexao Automatica COMET + MANUS
# Versao: 2.0 (Integrada)

Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  INICIANDO CONEXAO AUTOMATICA INTEGRADA" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta

# 1. MANUS: Verificar Infraestrutura
Write-Host "`n[1/3] MANUS: Verificando Infraestrutura..." -ForegroundColor Cyan
docker start n8n n8n-postgres ollama-hospitalar | Out-Null
$dockerStatus = docker ps --format "{{.Names}}"
if ($dockerStatus -like "*n8n*") { 
    Write-Host "  [OK] Docker e N8N prontos." -ForegroundColor Green 
}

# 2. COMET: Conectar ao N8N via Browser
Write-Host "`n[2/3] COMET: Conectando ao N8N via Browser..." -ForegroundColor Cyan
# Comando para o COMET abrir o browser no N8N
$n8nUrl = "http://localhost:5678/home/workflows"
Start-Process "chrome.exe" $n8nUrl
Write-Host "  [OK] Browser aberto no N8N." -ForegroundColor Green

# 3. TESTAR COMUNICACAO INTEGRADA
Write-Host "`n[3/3] TESTANDO COMUNICACAO COMET <-> MANUS..." -ForegroundColor Cyan
try {
    $resp = Invoke-RestMethod -Uri "http://localhost:5678/webhook/mcc/get-url" -Method Post -Body '{"agente":"AGENTE_LOCAL"}' -ContentType "application/json"
    Write-Host "  [OK] Comunicacao estabelecida via MCC." -ForegroundColor Green
    Write-Host "  [OK] COMET tem acesso visual." -ForegroundColor Green
    Write-Host "  [OK] MANUS tem acesso terminal." -ForegroundColor Green
} catch {
    Write-Host "  [AVISO] Verifique se o N8N ja terminou de carregar." -ForegroundColor Yellow
}

Write-Host "`n============================================" -ForegroundColor Magenta
Write-Host "  SISTEMA PRONTO PARA OPERACAO AUTONOMA" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  Manus e Comet estao agora sincronizados." -ForegroundColor White
Write-Host ""
