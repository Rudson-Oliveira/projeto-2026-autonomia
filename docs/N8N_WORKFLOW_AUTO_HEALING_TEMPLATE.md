# 🚀 N8N Workflow Template: Auto-Healing para Orçamentos

Este template de workflow n8n foi projetado para aumentar a resiliência do processamento de orçamentos, incorporando mecanismos de tratamento de erros (Try/Catch) e retentativas automáticas. Ele garante que falhas temporárias na comunicação com o Ollama ou outros serviços não interrompam o fluxo de trabalho, minimizando a intervenção humana.

## 💡 Funcionalidades:
- **Tratamento de Erros:** Captura exceções em nós críticos (ex: requisições HTTP para o Ollama).
- **Retentativas Automáticas:** Tenta novamente a operação após um breve intervalo em caso de falha.
- **Notificação de Falha:** Envia alertas para o Hub Central (ou outro canal configurado) em caso de falha persistente.
- **Fallback:** Possibilidade de implementar lógica de fallback (ex: usar um modelo Ollama diferente ou um LLM de nuvem).

## 🛠️ Como Usar:
1.  **Baixe o JSON:** Copie o conteúdo JSON abaixo.
2.  **Importe no n8n:** No seu n8n local, vá em `Workflows` -> `New` -> `Import from JSON`.
3.  **Configure:** Ajuste os nós de requisição HTTP para apontar para o seu Ollama local (`http://localhost:11434/api/generate`).
4.  **Ative:** Publique o workflow.

## 📄 JSON do Workflow (Exemplo Simplificado):

```json
{
  "nodes": [
    {
      "parameters": {},
      "name": "Start",
      "type": "n8n-nodes-base.start",
      "typeVersion": 1,
      "id": "b1c2d3e4-f5a6-7890-1234-567890abcdef",
      "startNode": true,
      "position": [240, 300]
    },
    {
      "parameters": {
        "mode": "runOnce",
        "options": {}
      },
      "name": "Try_Ollama_Request",
      "type": "n8n-nodes-base.tryCatch",
      "typeVersion": 1,
      "position": [440, 300]
    },
    {
      "parameters": {
        "url": "http://localhost:11434/api/generate",
        "method": "POST",
        "bodyParameters": [
          {
            "name": "model",
            "value": "phi3"
          },
          {
            "name": "prompt",
            "value": "Extraia o valor total e os itens deste orçamento: {{ $json.orcamento }}"
          },
          {
            "name": "stream",
            "value": false
          }
        ],
        "options": {
          "retryOnFail": true,
          "retryInterval": 10000,
          "retryAttempts": 3
        }
      },
      "name": "HTTP_Request_Ollama",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [640, 200]
    },
    {
      "parameters": {
        "content": "Falha na extração do orçamento: {{ $json.orcamento }}. Erro: {{ $json.error }}",
        "options": {}
      },
      "name": "Notify_Failure",
      "type": "n8n-nodes-base.noOp",
      "typeVersion": 1,
      "position": [640, 400]
    },
    {
      "parameters": {
        "value": "{{ $json.data }}",
        "options": {}
      },
      "name": "Process_Success",
      "type": "n8n-nodes-base.noOp",
      "typeVersion": 1,
      "position": [840, 200]
    }
  ],
  "connections": {
    "Start": [
      [
        {
          "node": "Try_Ollama_Request",
          "type": "main",
          "index": 0
        }
      ]
    ],
    "Try_Ollama_Request": [
      [
        {
          "node": "HTTP_Request_Ollama",
          "type": "main",
          "index": 0
        }
      ],
      [
        {
          "node": "Notify_Failure",
          "type": "main",
          "index": 0
        }
      ]
    ],
    "HTTP_Request_Ollama": [
      [
        {
          "node": "Process_Success",
          "type": "main",
          "index": 0
        }
      ]
    ]
  }
}
```

## ⚙️ Otimização de Memória para Ollama (Docker)

Para evitar que o Ollama trave devido à falta de memória, é crucial alocar recursos adequados ao container Docker. Recomenda-se um mínimo de 8GB de RAM para modelos como o `phi3`.

### 📝 Instruções:
1.  **Abra o Docker Desktop:** Vá para `Settings` (Configurações) -> `Resources` (Recursos) -> `Advanced` (Avançado).
2.  **Ajuste a Memória:** Aumente o limite de memória para **8GB ou mais**.
3.  **Aplique e Reinicie:** Clique em `Apply & Restart`.

Esta configuração garantirá que o Ollama tenha memória suficiente para carregar e processar os modelos sem interrupções.
