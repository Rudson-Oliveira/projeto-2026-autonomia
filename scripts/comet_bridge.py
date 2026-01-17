#!/usr/bin/env python3
# ============================================================
# COMET BRIDGE - Ponte de Comunicação Manus <-> Agentes Locais
# Autor: Manus AI
# Data: 17/01/2026
# Descrição: Servidor que permite ao Manus executar comandos locais
# ============================================================

from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import os
import sys
import json
import threading
import time
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Configurações
VERSION = "2.0"
START_TIME = datetime.now()

# Log de atividades
activity_log = []

def log_activity(action, details):
    """Registra atividade no log"""
    entry = {
        "timestamp": datetime.now().isoformat(),
        "action": action,
        "details": details
    }
    activity_log.append(entry)
    if len(activity_log) > 100:
        activity_log.pop(0)
    print(f"[{entry['timestamp']}] {action}: {details}")

@app.route('/health', methods=['GET'])
def health():
    """Endpoint de verificação de saúde"""
    uptime = (datetime.now() - START_TIME).total_seconds()
    return jsonify({
        "status": "online",
        "service": "MANUS-COMET-OBSIDIAN Bridge",
        "version": VERSION,
        "uptime_seconds": uptime,
        "obsidian": check_obsidian_status(),
        "ollama": check_ollama_status(),
        "timestamp": datetime.now().isoformat()
    })

def check_obsidian_status():
    """Verifica se o Obsidian está rodando"""
    try:
        result = subprocess.run(
            ['powershell', '-Command', 'Get-Process -Name "Obsidian" -ErrorAction SilentlyContinue'],
            capture_output=True, text=True, timeout=5
        )
        return "online" if result.stdout.strip() else "offline"
    except:
        return "unknown"

def check_ollama_status():
    """Verifica se o Ollama está rodando"""
    try:
        result = subprocess.run(
            ['powershell', '-Command', 'Test-NetConnection -ComputerName localhost -Port 11434 -InformationLevel Quiet'],
            capture_output=True, text=True, timeout=5
        )
        return "online" if "True" in result.stdout else "offline"
    except:
        return "unknown"

@app.route('/exec', methods=['POST'])
def execute():
    """Executa comandos PowerShell"""
    try:
        data = request.get_json()
        command = data.get('command', '')
        timeout = data.get('timeout', 60)
        
        log_activity("EXEC", f"Comando: {command[:100]}...")
        
        result = subprocess.run(
            ['powershell', '-Command', command],
            capture_output=True,
            text=True,
            timeout=timeout
        )
        
        response = {
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr,
            "return_code": result.returncode
        }
        
        log_activity("EXEC_RESULT", f"Success: {response['success']}")
        return jsonify(response)
        
    except subprocess.TimeoutExpired:
        log_activity("EXEC_TIMEOUT", f"Comando expirou após {timeout}s")
        return jsonify({
            "success": False,
            "output": "",
            "error": f"Comando expirou após {timeout} segundos"
        })
    except Exception as e:
        log_activity("EXEC_ERROR", str(e))
        return jsonify({
            "success": False,
            "output": "",
            "error": str(e)
        })

@app.route('/file/read', methods=['POST'])
def read_file():
    """Lê conteúdo de um arquivo"""
    try:
        data = request.get_json()
        path = data.get('path', '')
        
        log_activity("FILE_READ", path)
        
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return jsonify({
            "success": True,
            "content": content,
            "path": path
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/file/write', methods=['POST'])
def write_file():
    """Escreve conteúdo em um arquivo"""
    try:
        data = request.get_json()
        path = data.get('path', '')
        content = data.get('content', '')
        
        log_activity("FILE_WRITE", path)
        
        # Criar diretório se não existir
        os.makedirs(os.path.dirname(path), exist_ok=True)
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        return jsonify({
            "success": True,
            "path": path,
            "bytes_written": len(content)
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/obsidian/create', methods=['POST'])
def obsidian_create():
    """Cria uma nota no Obsidian"""
    try:
        data = request.get_json()
        vault_path = data.get('vault_path', r'C:\Users\rudpa\obsidian-agente')
        note_name = data.get('name', 'Nova Nota')
        content = data.get('content', '')
        folder = data.get('folder', '')
        
        if folder:
            full_path = os.path.join(vault_path, folder, f"{note_name}.md")
        else:
            full_path = os.path.join(vault_path, f"{note_name}.md")
        
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        
        with open(full_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        log_activity("OBSIDIAN_CREATE", full_path)
        
        return jsonify({
            "success": True,
            "path": full_path,
            "message": f"Nota criada: {note_name}"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/ollama/generate', methods=['POST'])
def ollama_generate():
    """Gera texto usando Ollama"""
    try:
        data = request.get_json()
        model = data.get('model', 'llama3.2')
        prompt = data.get('prompt', '')
        
        log_activity("OLLAMA_GENERATE", f"Model: {model}, Prompt: {prompt[:50]}...")
        
        import requests
        response = requests.post(
            'http://localhost:11434/api/generate',
            json={
                "model": model,
                "prompt": prompt,
                "stream": False
            },
            timeout=120
        )
        
        return jsonify({
            "success": True,
            "response": response.json()
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/services/status', methods=['GET'])
def services_status():
    """Retorna status de todos os serviços"""
    services = {
        "comet_bridge": {"port": 5000, "status": "online"},
        "obsidian_agent": {"port": 5001, "status": check_port(5001)},
        "hub_central": {"port": 5002, "status": check_port(5002)},
        "vision_server": {"port": 5003, "status": check_port(5003)},
        "ollama": {"port": 11434, "status": check_port(11434)},
        "jan": {"port": 4891, "status": check_port(4891)},
        "frontend": {"port": 5173, "status": check_port(5173)}
    }
    return jsonify(services)

def check_port(port):
    """Verifica se uma porta está em uso"""
    try:
        result = subprocess.run(
            ['powershell', '-Command', f'Test-NetConnection -ComputerName localhost -Port {port} -InformationLevel Quiet'],
            capture_output=True, text=True, timeout=5
        )
        return "online" if "True" in result.stdout else "offline"
    except:
        return "unknown"

@app.route('/log', methods=['GET'])
def get_log():
    """Retorna o log de atividades"""
    return jsonify({
        "log": activity_log[-50:],
        "total_entries": len(activity_log)
    })

@app.route('/ssh/exec', methods=['POST'])
def ssh_exec():
    """Executa comando SSH no servidor remoto"""
    try:
        data = request.get_json()
        host = data.get('host', 'dev.hospitalarsaude.app.br')
        user = data.get('user', 'usuario-ia')
        key_path = data.get('key_path', r'C:\Users\rudpa\Downloads\usuario-ia-chave.pem')
        command = data.get('command', 'ls -la')
        
        ssh_command = f'ssh -i "{key_path}" -o StrictHostKeyChecking=no {user}@{host} "{command}"'
        
        log_activity("SSH_EXEC", f"{user}@{host}: {command[:50]}...")
        
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
        return jsonify({
            "success": False,
            "error": str(e)
        })

if __name__ == '__main__':
    print("=" * 60)
    print("  COMET BRIDGE v" + VERSION)
    print("  Ponte de Comunicação Manus <-> Agentes Locais")
    print("=" * 60)
    print("")
    print("🚀 Servidor iniciado na porta 5000")
    print("📡 Aguardando conexões do Manus...")
    print("")
    print("Endpoints disponíveis:")
    print("  GET  /health          - Verificar status")
    print("  POST /exec            - Executar comando PowerShell")
    print("  POST /file/read       - Ler arquivo")
    print("  POST /file/write      - Escrever arquivo")
    print("  POST /obsidian/create - Criar nota no Obsidian")
    print("  POST /ollama/generate - Gerar texto com Ollama")
    print("  GET  /services/status - Status de todos os serviços")
    print("  POST /ssh/exec        - Executar comando SSH remoto")
    print("  GET  /log             - Ver log de atividades")
    print("")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)
