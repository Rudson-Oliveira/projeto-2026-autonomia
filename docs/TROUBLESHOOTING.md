# 🛠️ Guia de Troubleshooting e Auto-Healing

Este documento registra falhas identificadas e as soluções aplicadas automaticamente pelos agentes MANUS e COMET.

## 1. Falhas de Conexão com Ollama
- **Sintoma:** Porta 11434 aberta, mas conexões de API recusadas (Connection Refused).
- **Causa Provável:** Serviço interno do Ollama travado ou sobrecarga de memória no container.
- **Solução Aplicada:** Reinicialização do container via COMET (`docker restart ollama-hospitalar`).
- **Data:** 07/01/2026

## 2. Erros de Timeout no n8n
- **Sintoma:** Workflows de orçamentos demorando mais de 60s.
- **Causa Provável:** Modelos LLM lentos ou muitos processos simultâneos.
- **Solução Aplicada:** Otimização dos parâmetros `num_predict` e `stream: false`.


## 3. Falha Sistêmica: Failure Rate de 91% (n8n Cloud)
- **Sintoma:** 566 falhas em 622 execuções (Failure Rate: 91%).
- **Causa Provável:** Quebra de túnel de comunicação entre a n8n Cloud e os serviços locais (Ollama/n8n Local).
- **Ação em Curso:** Auditoria de logs de erro via COMET para identificar o código de erro exato (ECONNREFUSED/TIMEOUT).
- **Data:** 07/01/2026


## 4. Falha de Conexão Ollama (Diagnóstico Confirmado)
- **Sintoma:** `"The connection was aborted, perhaps the server is offline"` no nó `HTTP Request` do n8n, com timeout de 5 minutos.
- **Causa Raiz:** Ollama inacessível ou travado, impedindo o processamento de requisições API, apesar da porta estar aberta.
- **Solução Proposta:** Limpeza e reinicialização forçada do container Ollama (`docker stop`, `docker rm`, `docker run`).
- **Status:** Solução em execução via COMET.
- **Data:** 07/01/2026
