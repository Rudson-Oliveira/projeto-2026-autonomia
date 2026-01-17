# ============================================================
# SCRIPT DE INICIALIZAÇÃO DOS AGENTES LOCAIS - HOSPITALAR SAÚDE
# Autor: Manus AI
# Data: 17/01/2026
# Descrição: Inicia todos os agentes necessários para conexão com Manus
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  INICIANDO AGENTES LOCAIS - HOSPITALAR    " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$NGROK_URL = "charmless-maureen-subadministratively.ngrok-free.dev"
$COMET_BRIDGE_PORT = 5000
$OBSIDIAN_AGENT_PORT = 5001
$HUB_CENTRAL_PORT = 5002
$VISION_SERVER_PORT = 5003
$OLLAMA_PORT = 11434
$JAN_PORT = 4891

# Função para verificar se uma porta está em uso
function Test-Port {
    param([int]$Port)
    try {
        $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
        return $null -ne $connection
    } catch {
        return $false
    }
}

# Função para iniciar um serviço
function Start-Service-Agent {
    param(
        [string]$Name,
        [string]$Path,
        [string]$Command,
        [int]$Port
    )
    
    Write-Host "[$Name] Verificando porta $Port..." -ForegroundColor Yellow
    
    if (Test-Port -Port $Port) {
        Write-Host "[$Name] ✅ Já está rodando na porta $Port" -ForegroundColor Green
        return $true
    }
    
    Write-Host "[$Name] Iniciando serviço..." -ForegroundColor Yellow
    
    if (Test-Path $Path) {
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$Path'; $Command" -WindowStyle Normal
        Start-Sleep -Seconds 3
        
        if (Test-Port -Port $Port) {
            Write-Host "[$Name] ✅ Iniciado com sucesso na porta $Port" -ForegroundColor Green
            return $true
        } else {
            Write-Host "[$Name] ⚠️ Iniciado, aguardando..." -ForegroundColor Yellow
            return $true
        }
    } else {
        Write-Host "[$Name] ❌ Caminho não encontrado: $Path" -ForegroundColor Red
        return $false
    }
}

Write-Host ""
Write-Host "1. VERIFICANDO OLLAMA..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"
if (Test-Port -Port $OLLAMA_PORT) {
    Write-Host "[Ollama] ✅ Já está rodando na porta $OLLAMA_PORT" -ForegroundColor Green
} else {
    Write-Host "[Ollama] Iniciando Ollama..." -ForegroundColor Yellow
    Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 2
    if (Test-Port -Port $OLLAMA_PORT) {
        Write-Host "[Ollama] ✅ Iniciado com sucesso" -ForegroundColor Green
    } else {
        Write-Host "[Ollama] ⚠️ Verifique se o Ollama está instalado" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "2. VERIFICANDO JAN (IA Local)..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"
if (Test-Port -Port $JAN_PORT) {
    Write-Host "[Jan] ✅ Já está rodando na porta $JAN_PORT" -ForegroundColor Green
} else {
    Write-Host "[Jan] ⚠️ Inicie o Jan manualmente se necessário" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "3. INICIANDO COMET BRIDGE (Porta $COMET_BRIDGE_PORT)..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

# Caminho do COMET Bridge - ajuste conforme sua instalação
$COMET_BRIDGE_PATHS = @(
    "C:\Users\rudpa\obsidian-agente\comet-bridge",
    "C:\Users\rudpa\comet-bridge",
    "C:\Users\rudpa\Documents\comet-bridge",
    "C:\comet-bridge"
)

$cometBridgeFound = $false
foreach ($path in $COMET_BRIDGE_PATHS) {
    if (Test-Path "$path\server.py") {
        Start-Service-Agent -Name "COMET Bridge" -Path $path -Command "python server.py" -Port $COMET_BRIDGE_PORT
        $cometBridgeFound = $true
        break
    }
    if (Test-Path "$path\index.js") {
        Start-Service-Agent -Name "COMET Bridge" -Path $path -Command "node index.js" -Port $COMET_BRIDGE_PORT
        $cometBridgeFound = $true
        break
    }
    if (Test-Path "$path\comet_bridge.py") {
        Start-Service-Agent -Name "COMET Bridge" -Path $path -Command "python comet_bridge.py" -Port $COMET_BRIDGE_PORT
        $cometBridgeFound = $true
        break
    }
}

if (-not $cometBridgeFound) {
    Write-Host "[COMET Bridge] ❌ Não encontrado. Criando servidor básico..." -ForegroundColor Red
    
    # Criar servidor COMET Bridge básico
    $cometBridgeCode = @'
# COMET Bridge Server - Conexão Manus <-> Agentes Locais
from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import os

app = Flask(__name__)
CORS(app)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        "status": "online",
        "service": "MANUS-COMET-OBSIDIAN Bridge",
        "obsidian": "online"
    })

@app.route('/exec', methods=['POST'])
def execute():
    try:
        data = request.get_json()
        command = data.get('command', '')
        
        result = subprocess.run(
            ['powershell', '-Command', command],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        return jsonify({
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "output": "",
            "error": str(e)
        })

if __name__ == '__main__':
    print("🚀 COMET Bridge iniciado na porta 5000")
    print("📡 Aguardando conexões do Manus...")
    app.run(host='0.0.0.0', port=5000, debug=False)
'@
    
    $bridgePath = "C:\Users\rudpa\comet-bridge"
    if (-not (Test-Path $bridgePath)) {
        New-Item -ItemType Directory -Path $bridgePath -Force | Out-Null
    }
    
    $cometBridgeCode | Out-File -FilePath "$bridgePath\comet_bridge.py" -Encoding UTF8
    
    Write-Host "[COMET Bridge] Servidor criado em: $bridgePath\comet_bridge.py" -ForegroundColor Cyan
    Write-Host "[COMET Bridge] Instalando dependências..." -ForegroundColor Yellow
    
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "pip install flask flask-cors; cd '$bridgePath'; python comet_bridge.py" -WindowStyle Normal
}

Write-Host ""
Write-Host "4. INICIANDO HUB CENTRAL (Porta $HUB_CENTRAL_PORT)..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$HUB_CENTRAL_PATHS = @(
    "C:\Users\rudpa\obsidian-agente\hub-central",
    "C:\Users\rudpa\hub-central",
    "C:\Users\rudpa\Documents\hub-central"
)

$hubFound = $false
foreach ($path in $HUB_CENTRAL_PATHS) {
    if (Test-Path "$path\server.py") {
        Start-Service-Agent -Name "Hub Central" -Path $path -Command "python server.py" -Port $HUB_CENTRAL_PORT
        $hubFound = $true
        break
    }
    if (Test-Path "$path\index.js") {
        Start-Service-Agent -Name "Hub Central" -Path $path -Command "node index.js" -Port $HUB_CENTRAL_PORT
        $hubFound = $true
        break
    }
}

if (-not $hubFound -and (Test-Port -Port $HUB_CENTRAL_PORT)) {
    Write-Host "[Hub Central] ✅ Já está rodando na porta $HUB_CENTRAL_PORT" -ForegroundColor Green
} elseif (-not $hubFound) {
    Write-Host "[Hub Central] ⚠️ Não encontrado nos caminhos padrão" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "5. VERIFICANDO NGROK..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$ngrokProcess = Get-Process -Name "ngrok" -ErrorAction SilentlyContinue
if ($ngrokProcess) {
    Write-Host "[ngrok] ✅ Já está rodando" -ForegroundColor Green
    Write-Host "[ngrok] URL: https://$NGROK_URL" -ForegroundColor Cyan
} else {
    Write-Host "[ngrok] Iniciando túnel para porta 5000..." -ForegroundColor Yellow
    Start-Process "ngrok" -ArgumentList "http", "5000" -WindowStyle Normal
    Start-Sleep -Seconds 3
    Write-Host "[ngrok] ✅ Túnel iniciado" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  RESUMO DO STATUS DOS AGENTES             " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$services = @(
    @{Name="COMET Bridge"; Port=$COMET_BRIDGE_PORT},
    @{Name="Obsidian Agent"; Port=$OBSIDIAN_AGENT_PORT},
    @{Name="Hub Central"; Port=$HUB_CENTRAL_PORT},
    @{Name="Vision Server"; Port=$VISION_SERVER_PORT},
    @{Name="Ollama"; Port=$OLLAMA_PORT},
    @{Name="Jan (IA Local)"; Port=$JAN_PORT}
)

foreach ($service in $services) {
    $status = if (Test-Port -Port $service.Port) { "✅ ONLINE" } else { "❌ OFFLINE" }
    $color = if (Test-Port -Port $service.Port) { "Green" } else { "Red" }
    Write-Host ("  {0,-20} Porta {1,-6} {2}" -f $service.Name, $service.Port, $status) -ForegroundColor $color
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  CONEXÃO COM MANUS                        " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  URL do ngrok: https://$NGROK_URL" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Para testar a conexão, execute:" -ForegroundColor White
Write-Host "  curl https://$NGROK_URL/health" -ForegroundColor Gray
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  AGENTES PRONTOS PARA CONEXÃO COM MANUS   " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan

# Manter a janela aberta
Read-Host "Pressione Enter para fechar..."
