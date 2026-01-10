@echo off
Set-StrictMode -Version Latest

# Variáveis de Ambiente (ajuste conforme necessário)
$HOSPITALAR_PROJECT_ROOT = "C:\Users\rudpa\Documents\hospitalar"
$BACKEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_backend"
$FRONTEND_PATH = Join-Path $HOSPITALAR_PROJECT_ROOT "hospitalar_frontend"
$OLLAMA_MODEL = "llama2" # Pode ser 'mistral', 'llama3', etc.
$NETWORK_DRIVE_UNC = "\\192.168.50.11\captação"
$NETWORK_DRIVE_MOUNT_POINT_CONTAINER = "/mnt/captacao" # Ponto de montagem dentro do container Docker

Write-Host "
===================================================================
🚀 INICIANDO IMPLEMENTAÇÃO TOTAL DO SISTEMA HOSPITALAR (AUTÔNOMO)
===================================================================
"

# --- Função para verificar e instalar Docker --- #
function Check-And-Install-Docker {
    Write-Host "[1/5] Verificando instalação do Docker e Docker Compose..."
    try {
        docker --version | Out-Null
        docker-compose --version | Out-Null
        Write-Host "Docker e Docker Compose já instalados. Pulando instalação."
    } catch {
        Write-Warning "Docker ou Docker Compose não encontrados. Por favor, instale-os manualmente e execute o script novamente."
        Write-Host "Instruções: https://docs.docker.com/desktop/install/windows-install/"
        exit 1
    }
}

# --- Função para aplicar Docker Compose e Ollama --- #
function Apply-Docker-Compose {
    Write-Host "[2/5] Aplicando nova configuração Docker Compose (Ollama e PostgreSQL)..."
    try {
        # Copiar arquivos docker-compose gerados
        Copy-Item -Path "$PSScriptRoot\docker-compose.yaml" -Destination "$HOSPITALAR_PROJECT_ROOT\docker-compose.yaml" -Force
        Copy-Item -Path "$PSScriptRoot\docker-compose.env" -Destination "$HOSPITALAR_PROJECT_ROOT\docker-compose.env" -Force

        Set-Location $HOSPITALAR_PROJECT_ROOT
        Write-Host "Parando containers existentes..."
        docker-compose down
        Write-Host "Iniciando novos containers..."
        docker-compose --env-file docker-compose.env up -d

        # Verificar se os containers subiram
        Start-Sleep -Seconds 10 # Dar um tempo para os containers iniciarem
        $runningContainers = docker ps --format "{{.Names}}"
        if ($runningContainers -notlike "*ollama*" -or $runningContainers -notlike "*hospitalar_postgres*") {
            Write-Warning "Nem todos os containers esperados (ollama, hospitalar_postgres) estão rodando. Verifique os logs."
            # exit 1 # Não sair, mas alertar
        }

        Write-Host "Baixando modelo Ollama ($OLLAMA_MODEL)... Isso pode levar alguns minutos."
        docker exec -it ollama ollama pull $OLLAMA_MODEL
        Write-Host "Configuração Docker Compose e Ollama aplicada com sucesso."
    } catch {
        Write-Error "Erro ao aplicar Docker Compose e Ollama: $($_.Exception.Message)"
        exit 1
    }
}

# --- Função para configurar Backend (Laravel) --- #
function Configure-Backend {
    Write-Host "[3/5] Configurando Backend Laravel..."
    try {
        # Copiar BudgetAnalysisService.php
        $serviceDir = Join-Path $BACKEND_PATH "app\Services"
        if (-not (Test-Path $serviceDir)) { New-Item -ItemType Directory -Path $serviceDir | Out-Null }
        Copy-Item -Path "$PSScriptRoot\BudgetAnalysisService.php" -Destination $serviceDir -Force

        # Atualizar .env do Laravel (simulado, pois o .env real está no container)
        # No ambiente real, você precisaria editar o .env dentro do container ou no host antes de subir o container
        # Para este script, vamos apenas garantir que a variável OLLAMA_ENDPOINT esteja no .env do host se ele existir
        $laravelEnvPath = Join-Path $BACKEND_PATH ".env"
        if (Test-Path $laravelEnvPath) {
            (Get-Content $laravelEnvPath) -replace "^OLLAMA_ENDPOINT=.*", "OLLAMA_ENDPOINT=http://ollama:11434" | Set-Content $laravelEnvPath
            if ((Get-Content $laravelEnvPath) -notlike "*OLLAMA_ENDPOINT=*") {
                Add-Content $laravelEnvPath "`nOLLAMA_ENDPOINT=http://ollama:11434"
            }
        } else {
            Write-Warning "Arquivo .env do Laravel não encontrado em $BACKEND_PATH. Por favor, configure OLLAMA_ENDPOINT manualmente."
        }

        # Configurar Filesystem para o drive de rede (simulado)
        # No ambiente real, isso seria feito em config/filesystems.php
        # E a montagem do volume no docker-compose.yaml (já adicionado no docker-compose.yaml gerado)
        Write-Host "Lembre-se de configurar a montagem do volume para o drive de rede no docker-compose.yaml e o filesystem no Laravel."
        Write-Host "Backend Laravel configurado com sucesso (verifique o .env e filesystems.php)."
    } catch {
        Write-Error "Erro ao configurar Backend Laravel: $($_.Exception.Message)"
        exit 1
    }
}

# --- Função para configurar Frontend (Angular/Vue) --- #
function Configure-Frontend {
    Write-Host "[4/5] Configurando Frontend (Angular/Vue)..."
    try {
        # Copiar menu-captacao.vue
        $frontendComponentsPath = Join-Path $FRONTEND_PATH "src\components" # Ajuste conforme a estrutura real do seu frontend
        if (-not (Test-Path $frontendComponentsPath)) { New-Item -ItemType Directory -Path $frontendComponentsPath | Out-Null }
        Copy-Item -Path "$PSScriptRoot\menu-captacao.vue" -Destination $frontendComponentsPath -Force

        # Copiar dashboard-vulnerability-margin.vue
        Copy-Item -Path "$PSScriptRoot\dashboard-vulnerability-margin.vue" -Destination $frontendComponentsPath -Force

        Write-Host "Frontend configurado com sucesso (componentes copiados)."
        Write-Host "Lembre-se de integrar os componentes no seu roteamento e layouts do frontend."
    } catch {
        Write-Error "Erro ao configurar Frontend: $($_.Exception.Message)"
        exit 1
    }
}

# --- Função para backup final no GitHub --- #
function Final-GitHub-Backup {
    Write-Host "[5/5] Realizando backup final no GitHub..."
    try {
        Set-Location "$PSScriptRoot"
        git add .
        git commit -m "Automated: Implementação total do sistema HospitaLar via PowerShell"
        git push origin master
        Write-Host "Backup final no GitHub concluído com sucesso."
    } catch {
        Write-Error "Erro ao realizar backup final no GitHub: $($_.Exception.Message)"
        exit 1
    }
}

# --- Execução das Funções --- #
Check-And-Install-Docker
Apply-Docker-Compose
Configure-Backend
Configure-Frontend
Final-GitHub-Backup

Write-Host "
===================================================================
✅ IMPLEMENTAÇÃO TOTAL CONCLUÍDA!
===================================================================
"
Write-Host "Por favor, siga as instruções no GUIA_INTEGRACAO_FINAL_HOSPITALAR.md para os passos finais de integração e testes."
Write-Host "Você pode acessar o guia em: https://github.com/Rudson-Oliveira/projeto-2026-autonomia/blob/master/GUIA_INTEGRACAO_FINAL_HOSPITALAR.md"

# Manter a janela aberta para o usuário ler as mensagens
# Read-Host "Pressione Enter para sair..."
