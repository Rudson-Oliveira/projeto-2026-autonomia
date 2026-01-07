# 📡 Estratégia de Monitoramento e Webhooks de Retorno Automático

Este documento descreve a implementação de webhooks de retorno automático e monitoramento proativo para o sistema Hospitalar. O objetivo é garantir que o MANUS receba feedback em tempo real sobre o status dos processos de automação de orçamentos, permitindo ações corretivas imediatas e minimizando a intervenção humana.

## 1. Webhooks de Retorno Automático (Feedback em Tempo Real)

Para que o MANUS possa monitorar o progresso e o resultado de cada orçamento processado, os workflows do n8n serão configurados para enviar webhooks de retorno (callbacks) para um endpoint centralizado.

### 1.1. Endpoint de Recebimento de Webhooks (n8n)

Um novo workflow no n8n será criado para atuar como o receptor central de todos os webhooks de retorno. Este workflow terá as seguintes responsabilidades:

- **Receber Eventos:** Capturar os dados enviados pelos workflows de orçamento (status, ID do orçamento, erros, etc.).
- **Processar Feedback:** Analisar o payload do webhook para determinar o status da operação (sucesso, falha, aviso).
- **Acionar Ações:** Com base no status, o workflow pode:
    - Atualizar o status do orçamento no banco de dados.
    - Enviar notificações para o MANUS (via API interna ou outro canal).
    - Acionar workflows de recuperação em caso de falha.

### 1.2. Estrutura do Payload do Webhook

O payload JSON enviado pelos workflows de orçamento para o webhook de retorno deve conter informações essenciais para o monitoramento:

```json
{
  "orcamento_id": "string",
  "status": "success" | "failed" | "pending",
  "mensagem": "string",
  "detalhes_erro": "string" | null,
  "timestamp": "ISO 8601 string"
}
```

## 2. Monitoramento Proativo e Alertas

Além dos webhooks de retorno, o MANUS implementará um sistema de monitoramento proativo para garantir a saúde contínua do ecossistema.

### 2.1. Monitoramento de Logs Centralizado

Os logs gerados pelos containers Docker (n8n, Ollama) serão centralizados e monitorados. O `WATCHDOG_AUTONOMIA.ps1` já é um primeiro passo, mas a integração com uma ferramenta de log aggregation (ex: ELK Stack, Grafana Loki) pode fornecer uma visão mais abrangente.

### 2.2. Alertas para o MANUS

Em caso de eventos críticos (ex: falha persistente de um workflow, Ollama offline, alta latência), o sistema enviará alertas diretamente para o MANUS. Isso pode ser feito via:

- **API Interna do MANUS:** Um endpoint dedicado para receber alertas.
- **Mensagens no Chat:** O MANUS pode ser configurado para receber notificações diretamente no ambiente de chat.

## 3. Integração com o Hub Central

O Hub Central, mencionado anteriormente, atuará como o ponto de orquestração para esses webhooks e alertas. Ele será responsável por:

- Expor os endpoints para os webhooks de retorno.
- Roteamento de alertas para o MANUS.
- Dashboards de monitoramento em tempo real (futuro).

Esta estratégia garantirá que o MANUS tenha visibilidade total e controle sobre o sistema, permitindo uma operação verdadeiramente autônoma e resiliente.
