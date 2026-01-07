# 📋 CHECKLIST DE INICIALIZAÇÃO DIÁRIA
## Projeto 2026 - Autonomia de Sistema

Este checklist deve ser executado pelo Manus AI no início de cada sessão de trabalho.

---

## ⚡ PASSO 1: SAÚDE DO SISTEMA

| Item | Comando PowerShell | Status Esperado |
|------|-------------------|-----------------|
| **Docker** | `docker ps` | n8n, ollama, postgres UP |
| **N8N** | `Invoke-WebRequest http://localhost:5678` | Status 200 |
| **Ollama** | `Invoke-RestMethod http://localhost:11434/api/tags` | Modelos listados |
| **MCC** | `Invoke-RestMethod http://localhost:5678/webhook/mcc/get-url` | Retorna JSON |

---

## 🤖 PASSO 2: CONEXÃO DE AGENTES

| Agente | Método de Teste | Status |
|--------|-----------------|--------|
| **COMET Desktop** | `py: print("Conectado")` | ✅ |
| **COMET Bridge** | `curl https://.../health` | ✅ |
| **Orquestrador** | Webhook POST /orquestrador-dinamico | ✅ |

---

## 📚 PASSO 3: VALIDAÇÃO DE WORKFLOWS

Verificar se os seguintes workflows estão **ATIVOS** e **PUBLICADOS**:
1.  **WF-MCC-GET-URL-GS** (ID: sQUdHBk2xx8YAf6w)
2.  **WF-ORQUESTRADOR-DINAMICO** (ID: NdO3l3D1cHqpLNDV)

---

## 🔐 PASSO 4: RENOVAÇÃO DE AUTONOMIA

1.  Ler `AUTORIZACAO.md`.
2.  Confirmar com o usuário: "Rudson, posso prosseguir com autonomia total?"

---

**Checklist concluído?** → Iniciar tarefas do dia.
