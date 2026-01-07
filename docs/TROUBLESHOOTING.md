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
