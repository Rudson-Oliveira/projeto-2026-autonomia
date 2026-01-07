# checklist-rapido.ps1
# Projeto 2026 - Hospitalar Solucoes em Saude
# Versao: 2.0

Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  CHECKLIST RAPIDO - PROJETO 2026" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

$totalErros = 0
$totalAvisos = 0

# ------------------------------------------
# PASSO 1: VERIFICAR CONTAINERS DOCKER
# ------------------------------------------
Write-Host "[1/5] VERIFICANDO CONTAINERS DOCKER" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

$containers = @("n8n", "ollama-hospitalar", "n8n-postgres")

foreach ($c in $containers) {
    $status = docker ps --filter "name=$c" --format "{{.Status}}" 2>$null
    if ($status) {
        Write-Host "  [OK] $c - $status" -ForegroundColor Green
    } else {
        Write-Host "  [ERRO] $c - Parado ou inexistente" -ForegroundColor Red
        Write-Host "         Comando: docker start $c" -ForegroundColor Yellow
        $totalErros++
    }
}

Write-Host ""

# ------------------------------------------
# PASSO 2: TESTAR PORTAS COM TEST-NETCONNECTION
# ------------------------------------------
Write-Host "[2/5] TESTANDO PORTAS" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

$portas = @{
    "N8N" = 5678
    "Ollama" = 11434
    "COMET Bridge" = 5000
    "Obsidian Agent" = 5001
    "Hub Central" = 5002
    "Vision Server" = 5003
    "Jan IA" = 4891
    "Portainer" = 9000
    "Grafana" = 3001
}

$portasCriticas = @("N8N", "Ollama")

foreach ($nome in $portas.Keys) {
    $porta = $portas[$nome]
    $teste = Test-NetConnection -ComputerName localhost -Port $porta -WarningAction SilentlyContinue -InformationLevel Quiet
    
    if ($teste) {
        Write-Host "  [OK] $nome (porta $porta) - Aberta" -ForegroundColor Green
    } else {
        if ($portasCriticas -contains $nome) {
            Write-Host "  [ERRO] $nome (porta $porta) - Fechada (CRITICO)" -ForegroundColor Red
            $totalErros++
        } else {
            Write-Host "  [AVISO] $nome (porta $porta) - Fechada (opcional)" -ForegroundColor Yellow
            $totalAvisos++
        }
    }
}

Write-Host ""

# ------------------------------------------
# PASSO 3: VERIFICAR MODELOS OLLAMA
# ------------------------------------------
Write-Host "[3/5] VERIFICANDO MODELOS OLLAMA" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

try {
    $ollamaResp = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 10
    $modelos = $ollamaResp.models
    
    if ($modelos -and $modelos.Count -gt 0) {
        Write-Host "  [OK] Modelos disponiveis:" -ForegroundColor Green
        foreach ($m in $modelos) {
            Write-Host "       - $($m.name)" -ForegroundColor White
        }
    } else {
        Write-Host "  [ERRO] Nenhum modelo carregado" -ForegroundColor Red
        Write-Host "         Comando: ollama pull phi3" -ForegroundColor Yellow
        $totalErros++
    }
} catch {
    Write-Host "  [ERRO] Ollama nao respondeu" -ForegroundColor Red
    $totalErros++
}

Write-Host ""

# ------------------------------------------
# PASSO 4: TESTAR WEBHOOK MCC_CONFIG
# ------------------------------------------
Write-Host "[4/5] TESTANDO WEBHOOK MCC_CONFIG" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

try {
    $bodyMcc = '{"agente":"AGENTE_LOCAL"}'
    $mccResp = Invoke-RestMethod -Uri "http://localhost:5678/webhook/mcc/get-url" -Method Post -Body $bodyMcc -ContentType "application/json" -TimeoutSec 15
    
    if ($mccResp.service_name -or $mccResp[0].service_name) {
        Write-Host "  [OK] MCC_CONFIG respondeu corretamente" -ForegroundColor Green
        if ($mccResp.service_name) {
            Write-Host "       service_name: $($mccResp.service_name)" -ForegroundColor White
            Write-Host "       url: $($mccResp.url)" -ForegroundColor White
        } else {
            Write-Host "       service_name: $($mccResp[0].service_name)" -ForegroundColor White
            Write-Host "       url: $($mccResp[0].url)" -ForegroundColor White
        }
    } else {
        Write-Host "  [AVISO] MCC_CONFIG retornou vazio" -ForegroundColor Yellow
        $totalAvisos++
    }
} catch {
    Write-Host "  [ERRO] MCC_CONFIG falhou" -ForegroundColor Red
    Write-Host "         Verifique workflow: http://localhost:5678/workflow/sQUdHBk2xx8YAf6w" -ForegroundColor Yellow
    $totalErros++
}

Write-Host ""

# ------------------------------------------
# PASSO 5: TESTAR ORQUESTRADOR (OPCIONAL)
# ------------------------------------------
Write-Host "[5/5] TESTANDO ORQUESTRADOR (pode demorar)" -ForegroundColor Cyan
Write-Host "--------------------------------------------"

try {
    $bodyOrq = '{"agente":"AGENTE_LOCAL","mensagem":"Oi"}'
    $orqResp = Invoke-RestMethod -Uri "http://localhost:5678/webhook/orquestrador-dinamico" -Method Post -Body $bodyOrq -ContentType "application/json" -TimeoutSec 120
    
    if ($orqResp) {
        Write-Host "  [OK] Orquestrador respondeu!" -ForegroundColor Green
        $respJson = $orqResp | ConvertTo-Json -Compress
        if ($respJson.Length -gt 100) {
            Write-Host "       Resposta: $($respJson.Substring(0,100))..." -ForegroundColor White
        } else {
            Write-Host "       Resposta: $respJson" -ForegroundColor White
        }
    } else {
        Write-Host "  [AVISO] Orquestrador retornou vazio" -ForegroundColor Yellow
        $totalAvisos++
    }
} catch {
    Write-Host "  [AVISO] Orquestrador falhou ou timeout" -ForegroundColor Yellow
    Write-Host "         Workflow: http://localhost:5678/workflow/NdO3l3D1cHqpLNDV" -ForegroundColor Yellow
    $totalAvisos++
}

Write-Host ""

# ------------------------------------------
# RESUMO FINAL
# ------------------------------------------
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  RESUMO FINAL" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host ""

if ($totalErros -eq 0 -and $totalAvisos -eq 0) {
    Write-Host "  SUCESSO! Sistema 100% operacional" -ForegroundColor Green
} elseif ($totalErros -eq 0) {
    Write-Host "  OK com $totalAvisos aviso(s) - Sistema operacional" -ForegroundColor Yellow
} else {
    Write-Host "  ATENCAO! $totalErros erro(s) critico(s)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Comandos para corrigir:" -ForegroundColor Cyan
    Write-Host "    docker start n8n n8n-postgres ollama-hospitalar"
    Write-Host "    docker restart n8n"
    Write-Host "    ollama pull phi3"
}

Write-Host ""
Write-Host "  Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
Write-Host ""
Write-Host "============================================" -ForegroundColor Magenta
