@echo off
Set-StrictMode -Version Latest

# Variáveis de Ambiente (ajuste conforme necessário)
$HOSPITALAR_PROJECT_ROOT = "C:\Users\rudpa\Documents\hospitalar"
$FRONTEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_frontend"
$FRONTEND_COMPONENTS_PATH = Join-Path $FRONTEND_PATH "src\components"
$FRONTEND_ROUTER_PATH = Join-Path $FRONTEND_PATH "src\router\index.js" # Exemplo para Vue Router
$FRONTEND_MAIN_JS_PATH = Join-Path $FRONTEND_PATH "src\main.js" # Exemplo para Vue main.js
$FRONTEND_CSS_PATH = Join-Path $FRONTEND_PATH "src\assets\styles\hospitalar-theme.css" # Caminho para o CSS do tema
$FRONTEND_MAIN_CSS_IMPORT_PATH = Join-Path $FRONTEND_PATH "src\main.js" # Ou outro arquivo CSS principal

Write-Host "
===================================================================
🎨 INICIANDO INTEGRAÇÃO FINAL DO FRONTEND HOSPITALAR (AUTÔNOMO)
===================================================================
"

# --- Função para copiar componentes --- #
function Copy-Frontend-Components {
    Write-Host "[1/3] Copiando componentes Vue/Angular para o projeto frontend..."
    try {
        if (-not (Test-Path $FRONTEND_COMPONENTS_PATH)) {
            New-Item -ItemType Directory -Path $FRONTEND_COMPONENTS_PATH -Force | Out-Null
        }
        Copy-Item -Path "$PSScriptRoot\menu-captacao.vue" -Destination $FRONTEND_COMPONENTS_PATH -Force
        Copy-Item -Path "$PSScriptRoot\dashboard-vulnerability-margin.vue" -Destination $FRONTEND_COMPONENTS_PATH -Force
        Write-Host "Componentes copiados com sucesso para $FRONTEND_COMPONENTS_PATH."
    } catch {
        Write-Error "Erro ao copiar componentes frontend: $($_.Exception.Message)"
        exit 1
    }
}

# --- Função para configurar roteamento (Exemplo Vue Router) --- #
function Configure-Frontend-Routing {
    Write-Host "[2/3] Configurando roteamento do frontend (Exemplo Vue Router)..."
    try {
        if (Test-Path $FRONTEND_ROUTER_PATH) {
            $routerContent = Get-Content $FRONTEND_ROUTER_PATH

            # Adicionar imports dos novos componentes
            $importMenu = "import MenuCaptacao from '@components/menu-captacao.vue'"
            $importDashboard = "import VulnerabilityDashboard from '@components/dashboard-vulnerability-margin.vue'"

            if ($routerContent -notlike "*$importMenu*") {
                $routerContent = $routerContent -replace "(import VueRouter from 'vue-router')", "`$1`n`$importMenu`n`$importDashboard`n"
            }

            # Adicionar novas rotas
            $newRoutes = @"
    {
        path: '/captacao',
        component: () => import('@/layouts/MainLayout.vue'), // Ajuste para o seu layout principal
        children: [
            { path: 'orcamentos/analise', name: 'VulnerabilityAnalysis', component: VulnerabilityDashboard },
            // Adicione outras rotas do menu aqui, se necessário
        ]
    },
"@

            # Tentar injetar as rotas antes da última rota ou antes do fechamento do array
            if ($routerContent -notlike "*path: '/captacao'*") {
                $routerContent = $routerContent -replace "(\s*]\s*\n})", "`$newRoutes`n`$1"
            }

            Set-Content -Path $FRONTEND_ROUTER_PATH -Value $routerContent
            Write-Host "Roteamento do frontend atualizado (verifique e ajuste manualmente se necessário)."
        } else {
            Write-Warning "Arquivo de roteamento não encontrado em $FRONTEND_ROUTER_PATH. Por favor, configure as rotas manualmente."
        }
    } catch {
        Write-Error "Erro ao configurar roteamento do frontend: $($_.Exception.Message)"
        exit 1
    }
}

# --- Função para aplicar tema CSS --- #
function Apply-CSS-Theme {
    Write-Host "[3/3] Aplicando tema CSS (hospitalar-theme.css)..."
    try {
        # Copiar o arquivo CSS do tema para o diretório de assets do frontend
        if (-not (Test-Path (Split-Path $FRONTEND_CSS_PATH))) {
            New-Item -ItemType Directory -Path (Split-Path $FRONTEND_CSS_PATH) -Force | Out-Null
        }
        Copy-Item -Path "$PSScriptRoot\hospitalar-theme.css" -Destination $FRONTEND_CSS_PATH -Force

        # Adicionar import do CSS no arquivo principal (ex: main.js ou App.vue)
        if (Test-Path $FRONTEND_MAIN_CSS_IMPORT_PATH) {
            $mainJsContent = Get-Content $FRONTEND_MAIN_CSS_IMPORT_PATH
            $cssImport = "import '@assets/styles/hospitalar-theme.css';" # Ajuste o caminho conforme seu projeto

            if ($mainJsContent -notlike "*$cssImport*") {
                $mainJsContent = $mainJsContent -replace "(import Vue from 'vue')", "`$1`n`$cssImport`n"
            }
            Set-Content -Path $FRONTEND_MAIN_CSS_IMPORT_PATH -Value $mainJsContent
            Write-Host "Tema CSS copiado e importado (verifique e ajuste manualmente se necessário)."
        } else {
            Write-Warning "Arquivo principal do frontend ($FRONTEND_MAIN_CSS_IMPORT_PATH) não encontrado. Por favor, importe o CSS manualmente."
        }
    } catch {
        Write-Error "Erro ao aplicar tema CSS: $($_.Exception.Message)"
        exit 1
    }
}

# --- Execução das Funções --- #
Copy-Frontend-Components
Configure-Frontend-Routing
Apply-CSS-Theme

Write-Host "
===================================================================
✅ INTEGRAÇÃO FRONTEND CONCLUÍDA (VERIFICAÇÃO MANUAL NECESSÁRIA)!
===================================================================
"
Write-Host "Por favor, revise os arquivos modificados e faça os ajustes manuais necessários para o seu framework (Angular/Vue) e estrutura de projeto específicos."
Write-Host "Consulte o GUIA_INTEGRACAO_FINAL_HOSPITALAR.md para mais detalhes."

# Manter a janela aberta para o usuário ler as mensagens
# Read-Host "Pressione Enter para sair..."
