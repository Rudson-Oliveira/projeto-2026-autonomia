# 🚀 N8N API Gateway Template: Centralização e Autenticação

Este template de workflow n8n foi projetado para atuar como um **API Gateway centralizado** para o sistema Hospitalar. Ele permite que o MANUS orquestre todas as chamadas de API de forma segura, gerenciando autenticação, roteamento e tratamento de erros, minimizando a complexidade nos workflows de automação de orçamentos.

## 💡 Funcionalidades:
- **Autenticação Centralizada:** Gerencia o token de acesso (`@hospitalar_token`) e o 2FA, garantindo que apenas requisições autorizadas cheguem ao backend.
- **Roteamento Dinâmico:** Encaminha as requisições para os endpoints corretos do backend do Hospitalar com base nos parâmetros da requisição.
- **Tratamento de Erros:** Captura exceções e falhas de comunicação com o backend, retornando respostas padronizadas ou acionando alertas.
- **Log de Auditoria:** Registra todas as requisições e respostas para fins de auditoria e depuração.

## 🛠️ Como Usar:
1.  **Baixe o JSON:** Copie o conteúdo JSON abaixo.
2.  **Importe no n8n:** No seu n8n local, vá em `Workflows` -> `New` -> `Import from JSON`.
3.  **Configure:**
    *   **Credenciais:** Configure as credenciais de autenticação (e-mail, senha, 2FA) para obter o token de acesso.
    *   **Endpoints:** Ajuste os nós de requisição HTTP para apontar para os endpoints reais do seu backend (ex: `https://dev.hospitalarsaude.app.br/api/budgets`).
4.  **Ative:** Publique o workflow.

## 📄 JSON do Workflow (Exemplo Simplificado):

```json
{
  "nodes": [
    {
      "parameters": {},
      "name": "Webhook_API_Gateway",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "id": "a1b2c3d4-e5f6-7890-1234-567890abcdef",
      "startNode": true,
      "position": [240, 300]
    },
    {
      "parameters": {
        "url": "https://dev.hospitalarsaude.app.br/api/auth/login",
        "method": "POST",
        "bodyParameters": [
          {
            "name": "email",
            "value": "{{ $env.HOSPITALAR_API_EMAIL }}"
          },
          {
            "name": "password",
            "value": "{{ $env.HOSPITALAR_API_PASSWORD }}"
          }
        ],
        "options": {
          "sendBody": "json"
        }
      },
      "name": "Authenticate_API",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [440, 200]
    },
    {
      "parameters": {
        "value": "{{ $json.data.token }}",
        "options": {}
      },
      "name": "Set_Auth_Token",
      "type": "n8n-nodes-base.setItem",
      "typeVersion": 1,
      "position": [640, 200]
    },
    {
      "parameters": {
        "url": "https://dev.hospitalarsaude.app.br/api/budgets",
        "method": "GET",
        "options": {
          "headers": [
            {
              "name": "Authorization",
              "value": "Bearer {{ $item("Set_Auth_Token").json.value }}"
            }
          ]
        }
      },
      "name": "Get_Budgets",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 3,
      "position": [840, 200]
    },
    {
      "parameters": {
        "responseMode": "responseNode",
        "responseData": "{{ $json }}"
      },
      "name": "Respond_API",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [1040, 200]
    },
    {
      "parameters": {
        "content": "Erro no API Gateway: {{ $error.message }}",
        "options": {}
      },
      "name": "Handle_Error",
      "type": "n8n-nodes-base.noOp",
      "typeVersion": 1,
      "position": [640, 400]
    }
  ],
  "connections": {
    "Webhook_API_Gateway": [
      [
        {
          "node": "Authenticate_API",
          "type": "main",
          "index": 0
        }
      ]
    ],
    "Authenticate_API": [
      [
        {
          "node": "Set_Auth_Token",
          "type": "main",
          "index": 0
        }
      ],
      [
        {
          "node": "Handle_Error",
          "type": "main",
          "index": 0
        }
      ]
    ],
    "Set_Auth_Token": [
      [
        {
          "node": "Get_Budgets",
          "type": "main",
          "index": 0
        }
      ]
    ],
    "Get_Budgets": [
      [
        {
          "node": "Respond_API",
          "type": "main",
          "index": 0
        }
      ],
      [
        {
          "node": "Handle_Error",
          "type": "main",
          "index": 0
        }
      ]
    ]
  }
}
```
```
