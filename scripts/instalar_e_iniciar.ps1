# ============================================================
# INSTALAÇÃO E INICIALIZAÇÃO RÁPIDA - HOSPITALAR SAÚDE
# Execute este script como Administrador
# ============================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  INSTALAÇÃO RÁPIDA - CONEXÃO COM MANUS    " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se está rodando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️ ATENÇÃO: Execute este script como Administrador!" -ForegroundColor Yellow
    Write-Host ""
}

# Criar pasta do projeto
$projectPath = "C:\Users\rudpa\manus-agentes"
if (-not (Test-Path $projectPath)) {
    New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
    Write-Host "📁 Pasta criada: $projectPath" -ForegroundColor Green
}

# 1. Instalar dependências Python
Write-Host ""
Write-Host "1. INSTALANDO DEPENDÊNCIAS PYTHON..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"
pip install flask flask-cors requests --quiet
Write-Host "✅ Dependências Python instaladas" -ForegroundColor Green

# 2. Criar o COMET Bridge
Write-Host ""
Write-Host "2. CRIANDO COMET BRIDGE..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$cometBridgeCode = @'
#!/usr/bin/env python3
from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

VERSION = "2.0"
START_TIME = datetime.now()

@app.route('/health', methods=['GET'])
def health():
    uptime = (datetime.now() - START_TIME).total_seconds()
    return jsonify({
        "status": "online",
        "service": "MANUS-COMET-OBSIDIAN Bridge",
        "version": VERSION,
        "uptime_seconds": uptime,
        "obsidian": "online",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/exec', methods=['POST'])
def execute():
    try:
        data = request.get_json()
        command = data.get('command', '')
        timeout = data.get('timeout', 60)
        
        result = subprocess.run(
            ['powershell', '-Command', command],
            capture_output=True,
            text=True,
            timeout=timeout
        )
        
        return jsonify({
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr
        })
    except subprocess.TimeoutExpired:
        return jsonify({"success": False, "output": "", "error": "Timeout"})
    except Exception as e:
        return jsonify({"success": False, "output": "", "error": str(e)})

@app.route('/file/read', methods=['POST'])
def read_file():
    try:
        data = request.get_json()
        path = data.get('path', '')
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        return jsonify({"success": True, "content": content})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/file/write', methods=['POST'])
def write_file():
    try:
        data = request.get_json()
        path = data.get('path', '')
        content = data.get('content', '')
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        return jsonify({"success": True, "path": path})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/ssh/exec', methods=['POST'])
def ssh_exec():
    try:
        data = request.get_json()
        host = data.get('host', 'dev.hospitalarsaude.app.br')
        user = data.get('user', 'usuario-ia')
        key_path = data.get('key_path', r'C:\Users\rudpa\Downloads\usuario-ia-chave.pem')
        command = data.get('command', 'ls -la')
        
        ssh_command = f'ssh -i "{key_path}" -o StrictHostKeyChecking=no {user}@{host} "{command}"'
        
        result = subprocess.run(
            ['powershell', '-Command', ssh_command],
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
        return jsonify({"success": False, "error": str(e)})

if __name__ == '__main__':
    print("=" * 50)
    print("  COMET BRIDGE v" + VERSION)
    print("  Conexao Manus <-> Agentes Locais")
    print("=" * 50)
    print("Servidor iniciado na porta 5000")
    print("Aguardando conexoes do Manus...")
    print("=" * 50)
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)
'@

$cometBridgeCode | Out-File -FilePath "$projectPath\comet_bridge.py" -Encoding UTF8
Write-Host "✅ COMET Bridge criado: $projectPath\comet_bridge.py" -ForegroundColor Green

# 3. Criar script de inicialização
Write-Host ""
Write-Host "3. CRIANDO SCRIPT DE INICIALIZAÇÃO..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$startScript = @'
@echo off
echo ============================================
echo   INICIANDO COMET BRIDGE
echo ============================================
cd /d C:\Users\rudpa\manus-agentes
python comet_bridge.py
pause
'@

$startScript | Out-File -FilePath "$projectPath\iniciar_comet.bat" -Encoding ASCII
Write-Host "✅ Script de inicialização criado" -ForegroundColor Green

# 4. Verificar ngrok
Write-Host ""
Write-Host "4. VERIFICANDO NGROK..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$ngrokInstalled = Get-Command ngrok -ErrorAction SilentlyContinue
if ($ngrokInstalled) {
    Write-Host "✅ ngrok está instalado" -ForegroundColor Green
} else {
    Write-Host "⚠️ ngrok não encontrado. Instalando via winget..." -ForegroundColor Yellow
    winget install ngrok.ngrok --accept-source-agreements --accept-package-agreements
}

# 5. Criar script para iniciar ngrok
$ngrokScript = @'
@echo off
echo ============================================
echo   INICIANDO NGROK - TUNEL PARA MANUS
echo ============================================
ngrok http 5000
'@

$ngrokScript | Out-File -FilePath "$projectPath\iniciar_ngrok.bat" -Encoding ASCII
Write-Host "✅ Script ngrok criado" -ForegroundColor Green

# 6. Criar atalho na área de trabalho
Write-Host ""
Write-Host "5. CRIANDO ATALHOS NA ÁREA DE TRABALHO..." -ForegroundColor Magenta
Write-Host "-------------------------------------------"

$desktopPath = [Environment]::GetFolderPath("Desktop")

# Atalho para COMET Bridge
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$desktopPath\Iniciar COMET Bridge.lnk")
$Shortcut.TargetPath = "$projectPath\iniciar_comet.bat"
$Shortcut.WorkingDirectory = $projectPath
$Shortcut.Save()

# Atalho para ngrok
$Shortcut2 = $WshShell.CreateShortcut("$desktopPath\Iniciar ngrok.lnk")
$Shortcut2.TargetPath = "$projectPath\iniciar_ngrok.bat"
$Shortcut2.WorkingDirectory = $projectPath
$Shortcut2.Save()

Write-Host "✅ Atalhos criados na área de trabalho" -ForegroundColor Green

# 7. Iniciar os serviços
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  INICIANDO SERVIÇOS...                    " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Iniciar COMET Bridge em nova janela
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$projectPath'; python comet_bridge.py" -WindowStyle Normal
Write-Host "🚀 COMET Bridge iniciado" -ForegroundColor Green

Start-Sleep -Seconds 3

# Iniciar ngrok em nova janela
Start-Process powershell -ArgumentList "-NoExit", "-Command", "ngrok http 5000" -WindowStyle Normal
Write-Host "🌐 ngrok iniciado" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  INSTALAÇÃO CONCLUÍDA!                    " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivos criados em: $projectPath" -ForegroundColor Yellow
Write-Host ""
Write-Host "PRÓXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "1. Copie a URL do ngrok (ex: https://xxxx.ngrok-free.dev)" -ForegroundColor White
Write-Host "2. Informe a URL ao Manus para conexão" -ForegroundColor White
Write-Host ""
Write-Host "Para testar, acesse no navegador:" -ForegroundColor Cyan
Write-Host "http://localhost:5000/health" -ForegroundColor Yellow
Write-Host ""

Read-Host "Pressione Enter para fechar..."
