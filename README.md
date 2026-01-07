# Projeto 2026 - Sistema de Automação Hospitalar com Agentes AI

Este repositório contém a documentação, scripts e configurações para o sistema de automação hospitalar, focado em alcançar **ZERO INTERVENÇÃO HUMANA** através da orquestração de agentes de Inteligência Artificial.

## Conteúdo

- `docs/`: Documentação completa do sistema, incluindo o Guia de Agentes e o Protocolo de Autorização.
- `scripts/`: Scripts PowerShell para inicialização e verificação do sistema.

## Inicialização e Autonomia

Para iniciar o sistema e garantir a autonomia dos agentes MANUS e COMET, siga as instruções no `docs/CHECKLIST_INICIALIZACAO.md` e consulte o `docs/AUTORIZACAO.md` para o protocolo de autonomia.

## Contato

Para dúvidas ou suporte, entre em contato com Rudson Oliveira (rud.pa@hotmail.com).

## 📋 ESTRUTURA DO REPOSITÓRIO

| Arquivo | Descrição |
|---------|-----------|
| **[AUTORIZACAO.md](./docs/AUTORIZACAO.md)** | Protocolo de autorização para autonomia total |
| **[CHECKLIST_INICIALIZACAO.md](./docs/CHECKLIST_INICIALIZACAO.md)** | Passo a passo para iniciar o dia |
| **[GUIA_COMPLETO_AGENTES.md](./docs/GUIA_COMPLETO_AGENTES.md)** | Catálogo completo de agentes e funções |
| **[CONEXAO_AUTO.ps1](./scripts/CONEXAO_AUTO.ps1)** | Script de conexão automática COMET + MANUS |

## ⚡ COMO INICIAR O DIA

1.  **Abra o PowerShell** no seu computador.
2.  **Execute o script de conexão automática:** `.\scripts\CONEXAO_AUTO.ps1`
3.  **Abra o Manus AI** e envie o comando:
    > "Manus, siga as orientações do repositório Projeto-2026-Autonomia. Analise o status e me dê a resposta no checklist." 
    *(O Manus irá verificar o `docs/CHECKLIST_INICIALIZACAO.md` e o `docs/AUTORIZACAO.md` para garantir a autonomia e o funcionamento correto do sistema.)*

## 🤖 AGENTES DISPONÍVEIS

- **MANUS AI:** Cérebro estratégico, orquestração de alto nível, acesso a terminal (Docker, Git), planejamento.
- **COMET Desktop Agent:** Braço operacional, interação visual (navegador), execução de scripts PowerShell/Python.
- **n8n (Personal Agents):** Plataforma de automação de fluxo de trabalho, conexão entre APIs, serviços e sistemas.
- **Ollama (Modelos AI):** Servidor local de modelos de linguagem (LLMs) para geração de texto e análise de linguagem natural.
- **Hub Central:** Agente de coordenação e comunicação entre os demais agentes.
- **Obsidian Agent:** Agente de gestão de conhecimento para indexação e busca em base de conhecimento.
- **Vision Server:** Agente de processamento de visão computacional para análise de imagens.

**Este repositório é a fonte da verdade para a operação do sistema.**
