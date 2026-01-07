# Guia Completo de Agentes para Automação e Orquestração Multi-Agente V2.0

**Autor:** Manus AI
**Data:** 07 de Janeiro de 2026

## 1. Introdução: Rumo à Autonomia Zero Intervenção Humana

Este guia detalha a arquitetura e operação do sistema de automação hospitalar, focado na integração de agentes de Inteligência Artificial para alcançar a **autonomia total** e **zero intervenção humana**. A colaboração estratégica entre **MANUS AI** (cérebro estratégico e infraestrutura) e **COMET Desktop Agent** (braço operacional e interação visual) é o pilar central desta nova versão.

## 2. Agentes do Ecossistema Hospitalar 2026

Nosso ecossistema é composto por diversos agentes, cada um com um papel específico e otimizado para a máxima eficiência.

| Agente | Descrição | Função Específica | Casos de Uso (Quando Usar) | Comandos de Exemplo (PowerShell / Python) | Pré-requisitos / Condições |
|---|---|---|---|---|---|
| **MANUS AI** | Agente estratégico e de infraestrutura. | Orquestração de alto nível, acesso a terminal (Docker, Git), planejamento, análise e tomada de decisão. | Gerenciamento de repositórios Git, execução de comandos de sistema, instalação de dependências, planejamento de tarefas complexas, análise de logs. | `gh repo clone <repo-name>` (Git) <br> `docker ps` (Docker) <br> `python3.11 <script.py>` (Python) | Acesso ao terminal, Docker Desktop, GitHub CLI (`gh`). |
| **COMET Desktop Agent V2.0** | Agente operacional com acesso visual. | Interação direta com interfaces gráficas (navegador), automação de UI, execução de scripts PowerShell/Python no ambiente Windows. | Automação de processos em sistemas web (n8n, ERPs), preenchimento de formulários, extração de dados visuais, execução de rotinas locais. | `.\[script.ps1]` (PowerShell) <br> `py: <script.py>` (Python) | Ambiente Windows, PowerShell 7+, Python 3.x, Chromium/Edge. |
| **n8n (Personal Agents)** | Plataforma de automação de fluxo de trabalho. | Conexão entre APIs, serviços e sistemas, orquestração de fluxos de dados, execução de lógica de negócios. | Automação de processamento de orçamentos, integração com WhatsApp, envio de notificações, automação de tarefas repetitivas. | `docker start n8n` (Docker) <br> Acesso via navegador: `http://localhost:5678` | Docker, n8n container rodando, acesso via navegador. |
| **Ollama (Modelos AI)** | Servidor local de modelos de linguagem (LLMs). | Geração de texto, análise de linguagem natural, sumarização, respostas a perguntas, processamento de dados não estruturados. | Análise de documentos médicos, geração de respostas para pacientes, sumarização de prontuários, suporte à decisão clínica. | `docker start ollama-hospitalar` (Docker) <br> `ollama run phi3 
run phi3 "Olá, como posso ajudar?"` | Docker, ollama-hospitalar container rodando, modelos baixados. |
| **Hub Central** | Agente de coordenação e comunicação. | Ponto central de comunicação entre agentes, roteamento de mensagens, gerenciamento de estados. | Sincronização de tarefas entre MANUS e COMET, notificação de eventos críticos, coordenação de fluxos complexos. | `docker start hub-central` (Docker) <br> `python3.11 -m hub_central.app` | Docker, hub-central container rodando, configuração de portas. |
| **Obsidian Agent** | Agente de gestão de conhecimento. | Indexação e busca em base de conhecimento, geração de relatórios, documentação dinâmica. | Criação e atualização automática de documentação, busca de protocolos médicos, acesso a informações de referência. | `docker start obsidian-agent` (Docker) <br> `python3.11 -m obsidian_agent.app` | Docker, obsidian-agent container rodando, base de conhecimento configurada. |
| **Vision Server** | Agente de processamento de visão computacional. | Análise de imagens médicas, reconhecimento de padrões, detecção de anomalias. | Análise de exames de imagem (raio-x, tomografia), detecção de anomalias em tempo real, suporte ao diagnóstico. | `docker start vision-server` (Docker) <br> `python3.11 -m vision_server.app` | Docker, vision-server container rodando, modelos de visão treinados. |

## 3. Fluxo de Decisão para Orquestração de Agentes (MANUS + COMET)

Para garantir a máxima autonomia e eficiência, o fluxo de decisão para a escolha e orquestração de agentes segue a lógica abaixo:

1.  **Identificação da Tarefa:** Qual é o objetivo principal da tarefa?
    *   **Tarefa de Infraestrutura/Estratégia (Terminal/Git/Docker)?** -> **MANUS AI**
    *   **Tarefa de Interação Visual (Navegador/UI)?** -> **COMET Desktop Agent**
    *   **Tarefa de Automação de Fluxo de Dados/APIs?** -> **n8n**
    *   **Tarefa de Processamento de Linguagem/Geração de Texto?** -> **Ollama**
    *   **Tarefa de Coordenação/Comunicação entre Agentes?** -> **Hub Central**
    *   **Tarefa de Gestão/Busca de Conhecimento?** -> **Obsidian Agent**
    *   **Tarefa de Análise de Imagens/Visão Computacional?** -> **Vision Server**

2.  **Orquestração MANUS + COMET (Obrigatória):**
    *   **MANUS** atua como o **orquestrador primário**. Ele define a estratégia, gerencia o ambiente (Docker, Git) e, quando necessário, delega tarefas operacionais ao **COMET**.
    *   **COMET** executa as ações no ambiente Windows, incluindo a interação direta com o navegador para acessar e operar os fluxos do **n8n**.
    *   **Exemplo de Fluxo Integrado:**
        1.  **MANUS** identifica a necessidade de processar um novo orçamento (via monitoramento de repositório Git ou trigger).
        2.  **MANUS** instrui **COMET** a abrir o navegador e navegar até o n8n (`http://localhost:5678/home/workflows`).
        3.  **COMET** interage com a UI do n8n para iniciar o fluxo de processamento de orçamento (`WF-ORCAMENTOS`).
        4.  O fluxo do **n8n** utiliza o **Ollama** para analisar os dados do orçamento e o **Hub Central** para notificar o **MANUS** sobre o progresso.
        5.  **MANUS** monitora o status via logs do Docker e, se necessário, ajusta a estratégia ou instrui **COMET** a intervir novamente.

## 4. Protocolo de Autonomia Persistente

Para garantir a autonomia contínua e a resiliência do sistema, mesmo em caso de reset de contexto ou memória, o seguinte protocolo deve ser seguido:

1.  **Fonte da Verdade:** O repositório GitHub `projeto-2026-autonomia` é a fonte primária de todas as configurações, scripts e autorizações.
2.  **Renovação de Autorização:** Em cada inicialização ou quando a autonomia for questionada, o **MANUS** deve:
    *   Acessar o repositório GitHub (`https://github.com/rudsonoliveira2323/projeto-2026-autonomia`).
    *   Ler o arquivo `AUTORIZACAO.md` para confirmar a permissão de operação autônoma.
    *   Ler o arquivo `CHECKLIST_INICIALIZACAO.md` para verificar o estado do sistema.
    *   Se necessário, solicitar ao usuário a renovação explícita da autorização, referenciando o conteúdo do `AUTORIZACAO.md`.
3.  **Melhorias Contínuas:** O **MANUS** está autorizado a implementar melhorias contínuas no sistema, atualizando o repositório GitHub com novas versões de scripts, documentação e fluxos de trabalho, sempre visando a **ZERO INTERVENÇÃO HUMANA**.

## 5. Referências

[1] Docker. *Docker Documentation*. Disponível em: [https://docs.docker.com/](https://docs.docker.com/)
[2] n8n. *n8n Documentation*. Disponível em: [https://docs.n8n.io/](https://docs.n8n.io/)
[3] Ollama. *Ollama Documentation*. Disponível em: [https://ollama.com/](https://ollama.com/)
[4] GitHub. *GitHub Docs*. Disponível em: [https://docs.github.com/](https://docs.github.com/)
[5] Microsoft. *PowerShell Documentation*. Disponível em: [https://docs.microsoft.com/en-us/powershell/](https://docs.microsoft.com/en-us/powershell/)
