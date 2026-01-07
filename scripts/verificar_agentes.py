# verificar_agentes.py
# Projeto 2026 - Verificacao Completa de Agentes
# Para usar no COMET V2.0: py: exec(open('verificar_agentes.py').read())
# Ou copie e cole no COMET com prefixo 'py:'

import subprocess
import requests
from datetime import datetime

def print_header(texto):
    print(f"\n{'='*50}")
    print(f"  {texto}")
    print(f"{'='*50}")

def print_ok(texto):
    print(f"  [OK] {texto}")

def print_erro(texto):
    print(f"  [ERRO] {texto}")

def print_aviso(texto):
    print(f"  [--] {texto}")

def verificar_docker():
    print("\n[1/7] DOCKER CONTAINERS")
    print("-" * 50)
    containers = ["n8n", "ollama-hospitalar", "n8n-postgres"]
    for c in containers:
        try:
            result = subprocess.run(
                ["docker", "ps", "--filter", f"name={c}", "--format", "{{.Status}}"],
                capture_output=True, text=True, timeout=10
            )
            if result.stdout.strip():
                print_ok(f"{c} - {result.stdout.strip()}")
            else:
                print_erro(f"{c} - Parado")
        except Exception as e:
            print_erro(f"{c} - Erro: {e}")

def verificar_portas():
    print("\n[2/7] PORTAS")
    print("-" * 50)
    import socket
    portas = [
        ("N8N", 5678),
        ("Ollama", 11434),
        ("COMET Bridge", 5000),
        ("Obsidian Agent", 5001),
        ("Hub Central", 5002),
        ("Vision Server", 5003),
        ("Jan IA", 4891),
        ("Portainer", 9000),
        ("Grafana", 3001),
        ("Mongo Express", 8085)
    ]
    for nome, porta in portas:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(2)
        result = sock.connect_ex(('localhost', porta))
        sock.close()
        if result == 0:
            print_ok(f"{nome} (porta {porta})")
        else:
            print_aviso(f"{nome} (porta {porta}) - Fechada")

def verificar_ollama():
    print("\n[3/7] MODELOS OLLAMA")
    print("-" * 50)
    try:
        r = requests.get("http://localhost:11434/api/tags", timeout=10)
        if r.status_code == 200:
            modelos = r.json().get("models", [])
            print_ok(f"Ollama Online - {len(modelos)} modelo(s)")
            for m in modelos:
                tamanho = round(m.get("size", 0) / (1024**3), 2)
                print(f"       - {m['name']} ({tamanho} GB)")
        else:
            print_erro("Ollama erro de resposta")
    except Exception as e:
        print_erro(f"Ollama offline - {e}")

def verificar_servicos():
    print("\n[4/7] SERVICOS HTTP")
    print("-" * 50)
    servicos = [
        ("N8N", "http://localhost:5678"),
        ("COMET Bridge", "http://localhost:5000/health"),
        ("Obsidian Agent", "http://localhost:5001/health"),
        ("Hub Central", "http://localhost:5002/health"),
        ("Vision Server", "http://localhost:5003/health"),
        ("Jan IA", "http://localhost:4891")
    ]
    for nome, url in servicos:
        try:
            r = requests.get(url, timeout=5)
            if r.status_code == 200:
                print_ok(f"{nome} - Online")
            else:
                print_aviso(f"{nome} - Status {r.status_code}")
        except:
            print_aviso(f"{nome} - Offline")

def verificar_mcc():
    print("\n[5/7] WEBHOOK MCC_CONFIG")
    print("-" * 50)
    try:
        r = requests.post(
            "http://localhost:5678/webhook/mcc/get-url",
            json={"agente": "AGENTE_LOCAL"},
            timeout=15
        )
        if r.status_code == 200:
            data = r.json()
            if isinstance(data, list):
                data = data[0]
            print_ok("MCC_CONFIG Online")
            print(f"       service_name: {data.get('service_name', 'N/A')}")
            print(f"       url: {data.get('url', 'N/A')}")
        else:
            print_erro(f"MCC_CONFIG - Status {r.status_code}")
    except Exception as e:
        print_erro(f"MCC_CONFIG - {e}")

def verificar_orquestrador():
    print("\n[6/7] ORQUESTRADOR DINAMICO")
    print("-" * 50)
    print("       (Aguarde ate 60s...)")
    try:
        r = requests.post(
            "http://localhost:5678/webhook/orquestrador-dinamico",
            json={"agente": "AGENTE_LOCAL", "mensagem": "Oi"},
            timeout=120
        )
        if r.status_code == 200:
            print_ok("Orquestrador Online")
            resp = str(r.json())[:80]
            print(f"       Resposta: {resp}...")
        else:
            print_aviso(f"Orquestrador - Status {r.status_code}")
    except Exception as e:
        print_aviso(f"Orquestrador - {e}")

def verificar_ngrok():
    print("\n[7/7] COMET BRIDGE (NGROK)")
    print("-" * 50)
    try:
        r = requests.get(
            "https://charmless-maureen-subadministratively.ngrok-free.dev/health",
            timeout=10
        )
        if r.status_code == 200:
            data = r.json()
            print_ok("COMET Bridge (ngrok) Online")
            print(f"       Status: {data.get('status', 'N/A')}")
            print(f"       Service: {data.get('service', 'N/A')}")
            print(f"       Obsidian: {data.get('obsidian', 'N/A')}")
        else:
            print_aviso("COMET Bridge (ngrok) - Erro")
    except:
        print_aviso("COMET Bridge (ngrok) - Offline")

def main():
    print_header(f"VERIFICACAO DE AGENTES - PROJETO 2026")
    print(f"  {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
    
    verificar_docker()
    verificar_portas()
    verificar_ollama()
    verificar_servicos()
    verificar_mcc()
    verificar_orquestrador()
    verificar_ngrok()
    
    print_header("VERIFICACAO CONCLUIDA")
    print("\n  Legenda:")
    print("    [OK]   = Funcionando")
    print("    [--]   = Opcional/Offline")
    print("    [ERRO] = Critico/Falhou")
    print()

if __name__ == "__main__":
    main()
