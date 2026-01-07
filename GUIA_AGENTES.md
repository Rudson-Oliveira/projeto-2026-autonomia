
# 🤖 GUIA COMPLETO DE AGENTES
## Projeto 2026 - Autonomia Total

**Versão:** 1.0
**Data:** 07/01/2026
**Autor:** Manus AI

---

## 🎯 OBJETIVO

Este guia é o **manual de operações** para o ecossistema de agentes do Projeto 2026. O objetivo é **maximizar a autonomia** e **minimizar a intervenção humana**, fornecendo um fluxo de decisão claro sobre qual agente usar para cada tarefa.

---

## 🌊 FLUXO DE DECISÃO: QUAL AGENTE USAR?

**Siga esta ordem para decidir qual agente usar:**

1.  **A tarefa pode ser feita com um comando de terminal?**
    *   **Sim** → Use **COMET Desktop Agent V2.0**

2.  **A tarefa envolve automação de processos, APIs ou agendamento?**
    *   **Sim** → Use **N8N** (via workflows existentes ou criando novos)

3.  **A tarefa requer geração de texto, análise de dados ou raciocínio?**
    *   **Sim** → Use **Ollama** (via Orquestrador Dinâmico no N8N)

4.  **A tarefa envolve acesso a notas, documentos ou base de conhecimento?**
    *   **Sim** → Use **Obsidian Agent**

5.  **A tarefa requer processamento de imagens ou visão computacional?**
    *   **Sim** → Use **Vision Server**

6.  **A tarefa precisa de comunicação entre múltiplos agentes?**
    *   **Sim** → Use **Hub Central** para rotear a requisição

7.  **A tarefa precisa ser exposta para a internet?**
    *   **Sim** → Use **COMET Bridge** (ngrok)

**Regra de Ouro:** Sempre comece pelo agente mais simples e direto (COMET). Escale para N8N e Ollama conforme a complexidade aumenta.

---

## 🛠️ CATÁLOGO DE AGENTES

### 1. COMET Desktop Agent V2.0

*   **O que faz:** Executa comandos PowerShell e Python diretamente no sistema operacional.
*   **Quando usar:** Para qualquer tarefa que possa ser resolvida com um script ou comando de terminal (manipulação de arquivos, instalação de pacotes, controle de serviços, etc).
*   **Pré-requisitos:** COMET V2.0 deve estar rodando.
*   **Comandos:**
    ```powershell
    # Executar comando PowerShell
    docker ps

    # Executar código Python
    py: print("Ola do Python")
    ```

---

### 2. N8N (Plataforma de Automação)

*   **O que faz:** Orquestra fluxos de trabalho complexos, integra APIs, agenda tarefas e gerencia os "Personal Agents".
*   **Quando usar:** Para automação de processos, tarefas agendadas, integração entre múltiplos serviços e quando um simples comando não é suficiente.
*   **Pré-requisitos:** Containers `n8n` e `n8n-postgres` devem estar rodando.
*   **Comandos:**
    ```powershell
    # Chamar um webhook de um workflow
    Invoke-RestMethod -Uri http://localhost:5678/webhook/meu-workflow -Method POST -Body $body

    # Listar workflows (precisa de API Key)
    Invoke-RestMethod -Uri http://localhost:5678/api/v1/workflows -Headers @{"X-N8N-API-KEY"="SUA_KEY"}
    ```

---

### 3. Ollama (IA Local)

*   **O que faz:** Gera texto, responde perguntas, analisa dados e executa tarefas de raciocínio. É o "cérebro" do sistema.
*   **Quando usar:** Sempre que precisar de inteligência, criatividade ou análise.
*   **Pré-requisitos:** Container `ollama-hospitalar` rodando e com modelos carregados.
*   **Comandos:**
    ```powershell
    # Teste direto (via PowerShell)
    $body = @{ model = "phi3:latest"; prompt = "Oi"; stream = $false } | ConvertTo-Json
    Invoke-RestMethod -Uri http://localhost:11434/api/generate -Method POST -Body $body

    # Uso recomendado (via Orquestrador N8N)
    $body = @{ agente = "AGENTE_LOCAL"; mensagem = "Oi" } | ConvertTo-Json
    Invoke-RestMethod -Uri http://localhost:5678/webhook/orquestrador-dinamico -Method POST -Body $body
    ```

---

### 4. N8N Personal Agents

*   **O que são:** Workflows N8N especializados que agem como agentes (ex: AGENT-JS-DEBUGGER, AGENTE-FRONTEND-FIXER).
*   **O que fazem:** Executam tarefas específicas e bem definidas (ex: debugar código JavaScript, corrigir CSS).
*   **Quando usar:** Para automatizar tarefas repetitivas que têm um fluxo de trabalho claro.
*   **Pré-requisitos:** N8N rodando e o workflow do agente ATIVO e PUBLICADO.
*   **Comandos:**
    ```powershell
    # Chamar o agente via webhook
    $body = @{ problema = "meu codigo JS esta com erro" } | ConvertTo-Json
    Invoke-RestMethod -Uri http://localhost:5678/webhook/agent-js-debugger -Method POST -Body $body
    ```

---

### 5. COMET Bridge (ngrok)

*   **O que faz:** Expõe serviços locais para a internet de forma segura via túnel ngrok.
*   **Quando usar:** Quando o Manus AI (ou outro serviço externo) precisa se comunicar com os agentes locais.
*   **Pré-requisitos:** COMET Bridge deve estar rodando e conectado ao ngrok.
*   **Comandos:**
    ```powershell
    # Verificar status do Bridge
    Invoke-RestMethod -Uri https://charmless-maureen-subadministratively.ngrok-free.dev/health
    ```

---

### 6. Hub Central, Obsidian Agent, Vision Server

*   **O que fazem:**
    *   **Hub Central:** Roteia requisições entre diferentes agentes.
    *   **Obsidian Agent:** Acessa e modifica a base de conhecimento no Obsidian.
    *   **Vision Server:** Processa e analisa imagens.
*   **Quando usar:** Para tarefas avançadas que requerem suas capacidades específicas.
*   **Pré-requisitos:** Seus respectivos serviços devem estar rodando.
*   **Comandos:**
    ```powershell
    # Verificar status
    Invoke-RestMethod -Uri http://localhost:5002/health # Hub
    Invoke-RestMethod -Uri http://localhost:5001/health # Obsidian
    Invoke-RestMethod -Uri http://localhost:5003/health # Vision
    ```

---

## ⚡ COMANDOS PRONTOS PARA O TERMINAL

### PowerShell

```powershell
# Iniciar todos os containers criticos
docker start n8n n8n-postgres ollama-hospitalar

# Reiniciar o N8N (para limpar cache)
docker restart n8n

# Verificar logs de um container
docker logs n8n

# Baixar um modelo no Ollama
ollama pull phi3

# Testar o Orquestrador Dinamico
$body = @{ agente = "AGENTE_LOCAL"; mensagem = "Resuma este texto: ..." } | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:5678/webhook/orquestrador-dinamico -Method POST -Body $body -ContentType "application/json"
```

### Python (para COMET V2.0)

```python
# Prefixo 'py:' no COMET

# Verificar status de todos os servicos
import requests; [print(f"{n}: {"Online" if requests.get(u, timeout=3).status_code == 200 else "Offline"}") for n, u in [("N8N", "http://localhost:5678"), ("Ollama", "http://localhost:11434"), ("Hub", "http://localhost:5002/health")]];

# Testar o Orquestrador Dinamico
import requests; body = {"agente": "AGENTE_LOCAL", "mensagem": "Resuma este texto: ..."}; r = requests.post("http://localhost:5678/webhook/orquestrador-dinamico", json=body); print(r.json())
```

---

## 🚀 OBJETIVO FINAL: AUTONOMIA

O objetivo é que o **Manus AI** possa usar o **COMET Bridge** para executar comandos no **COMET Desktop Agent**, que por sua vez pode chamar **N8N** e **Ollama**.

**Fluxo Autônomo Ideal:**
`Manus AI → COMET Bridge (ngrok) → COMET Desktop Agent → N8N/Ollama`

Para isso, o COMET Bridge precisa ter um endpoint `/execute` que aceite comandos e os execute no sistema.

---

**Este guia deve ser o ponto de partida para qualquer interação com o sistema.**
