# Script de Implementação Total do Sistema HospitaLar
Set-StrictMode -Version Latest

# Variáveis de Ambiente
$HOSPITALAR_PROJECT_ROOT = "C:\Users\rudpa\Documents\hospitalar"
$BACKEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_backend"
$FRONTEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_frontend"
$OLLAMA_MODEL = "llama2"
$NETWORK_DRIVE_UNC = "\\192.168.50.11\captação"

Write-Host "
===================================================================
🚀 INICIANDO IMPLEMENTACAO TOTAL DO SISTEMA HOSPITALAR
===================================================================
" -ForegroundColor Cyan

function Check-And-Install-Docker {
    Write-Host "[1/5] Verificando instalacao do Docker e Docker Compose..."
    try {
        docker --version | Out-Null
        docker-compose --version | Out-Null
        Write-Host "Docker e Docker Compose detectados."
    } catch {
        Write-Warning "Docker nao encontrado. Instale o Docker Desktop primeiro."
        exit 1
    }
}

function Apply-Docker-Compose {
    Write-Host "[2/5] Aplicando configuracao Docker (Ollama e PostgreSQL)..."
    try {
        Set-Location $HOSPITALAR_PROJECT_ROOT
        if (Test-Path "docker-compose.yaml") {
            docker-compose down
            docker-compose --env-file docker-compose.env up -d
            Write-Host "Containers iniciados. Baixando modelo $OLLAMA_MODEL..."
            docker exec -it ollama ollama pull $OLLAMA_MODEL
        } else {
            Write-Warning "Arquivo docker-compose.yaml nao encontrado em $HOSPITALAR_PROJECT_ROOT"
        }
    } catch {
        Write-Error "Erro no Docker: $($_.Exception.Message)"
    }
}

function Configure-Backend {
    Write-Host "[3/5] Configurando Backend Laravel..."
    $serviceDir = Join-Path $BACKEND_PATH "app\Services"
    if (-not (Test-Path $serviceDir)) { New-Item -ItemType Directory -Path $serviceDir -Force | Out-Null }
    
    $sourceService = Join-Path $HOSPITALAR_PROJECT_ROOT "BudgetAnalysisService.php"
    if (Test-Path $sourceService) {
        Copy-Item -Path $sourceService -Destination $serviceDir -Force
        Write-Host "Servico de Analise copiado para o Backend."
    }
}

function Configure-Frontend {
    Write-Host "[4/5] Configurando Frontend..."
    $frontendComponentsPath = Join-Path $FRONTEND_PATH "src\components"
    if (-not (Test-Path $frontendComponentsPath)) { New-Item -ItemType Directory -Path $frontendComponentsPath -Force | Out-Null }
    
    $components = @("menu-captacao.vue", "dashboard-vulnerability-margin.vue")
    foreach ($comp in $components) {
        $src = Join-Path $HOSPITALAR_PROJECT_ROOT $comp
        if (Test-Path $src) {
            Copy-Item -Path $src -Destination $frontendComponentsPath -Force
            Write-Host "Componente $comp copiado."
        }
    }
}

function Final-GitHub-Backup {
    Write-Host "[5/5] Sincronizando com GitHub..."
    try {
        git add .
        git commit -m "Fix: Correcao de scripts PowerShell e implementacao total"
        git push origin master
        Write-Host "Backup concluido."
    } catch {
        Write-Warning "Falha ao sincronizar com GitHub. Verifique suas credenciais."
    }
}

Check-And-Install-Docker
Apply-Docker-Compose
Configure-Backend
Configure-Frontend
Final-GitHub-Backup

Write-Host "
===================================================================
✅ IMPLEMENTACAO CONCLUIDA COM SUCESSO!
===================================================================
" -ForegroundColor Green
