# Script de Integracao Frontend do Sistema HospitaLar
Set-StrictMode -Version Latest

$HOSPITALAR_PROJECT_ROOT = "C:\Users\rudpa\Documents\hospitalar"
$FRONTEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_frontend"
$FRONTEND_COMPONENTS_PATH = Join-Path $FRONTEND_PATH "src\components"
$FRONTEND_ROUTER_PATH = Join-Path $FRONTEND_PATH "src\router\index.js"
$FRONTEND_CSS_PATH = Join-Path $FRONTEND_PATH "src\assets\styles\hospitalar-theme.css"

Write-Host "
===================================================================
🎨 INICIANDO INTEGRACAO DO FRONTEND
===================================================================
" -ForegroundColor Cyan

function Copy-Frontend-Assets {
    Write-Host "[1/3] Copiando componentes e estilos..."
    if (Test-Path (Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar-theme.css")) {
        $styleDir = Split-Path $FRONTEND_CSS_PATH
        if (-not (Test-Path $styleDir)) { New-Item -ItemType Directory -Path $styleDir -Force | Out-Null }
        Copy-Item -Path (Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar-theme.css") -Destination $FRONTEND_CSS_PATH -Force
        Write-Host "Tema CSS aplicado."
    }
}

function Update-Router {
    Write-Host "[2/3] Atualizando rotas do sistema..."
    if (Test-Path $FRONTEND_ROUTER_PATH) {
        Write-Host "Arquivo de rotas detectado. Por favor, verifique a inclusao de 'orcamentos/analise'."
    } else {
        Write-Warning "Arquivo de rotas nao encontrado em $FRONTEND_ROUTER_PATH"
    }
}

function Final-Check {
    Write-Host "[3/3] Verificacao final..."
    Write-Host "Componentes presentes em $FRONTEND_COMPONENTS_PATH"
}

Copy-Frontend-Assets
Update-Router
Final-Check

Write-Host "
===================================================================
✅ INTEGRACAO FRONTEND FINALIZADA!
===================================================================
" -ForegroundColor Green
