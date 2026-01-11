# 🧠 BASE DE CONHECIMENTO MESTRE - PROJETO HOSPITALAR 2026
**Data de Consolidação:** 10/01/2026  
**Status:** Autonomia Total Ativada

---

## 📋 VISÃO GERAL DO PROJETO
O sistema **HospitaLar** é uma plataforma de gestão de Home Care focada no **Módulo Orçamento (Captação)**. O objetivo é atingir a "Total Autonomia" no processamento de orçamentos multimodais (WhatsApp, Áudio, Imagem) com análise inteligente de complexidade e viabilidade financeira.

---

## 🛠️ ARQUITETURA TÉCNICA
- **Agente Multimodelo:** Obsidian Agent (Python Flask) - Roteamento inteligente de IAs e Plugins
- **RPA/Automação:** UiPath Orchestrator e Robots
- **Redundância de Navegação:** Playwright, Puppeteer, Selenium (orquestrados pelo Agente Multimodelo)

- **Backend:** Laravel (PHP) - Porta 8000
- **Frontend:** Angular/Vue - Porta 4200
- **Banco de Dados:** MySQL (Principal) e PostgreSQL (Expansão)
- **Automação:** n8n - Porta 5678
- **Inteligência Artificial:** Ollama (Llama2/Mistral) - Porta 11434
- **Infraestrutura:** Docker Compose

---

## 🧠 REGRAS DE NEGÓCIO E INTELIGÊNCIA (CORE)

### 1. 🧠 O Cérebro Central: Agente Multimodelo (Obsidian Agent)

O **Obsidian Agent** (repositório `obsidian-agente`) atua como o cérebro central da nossa arquitetura de IA. Ele é um serviço Python (Flask) que orquestra a comunicação com diversas IAs e plugins, incluindo o Ollama e, futuramente, a UiPath.

*   **Função:** Recebe requisições, analisa o conteúdo e decide qual provedor de IA ou plugin deve ser acionado.
*   **Roteamento Inteligente:** Possui um `AIRouter` (`ollama_integration.py`) que direciona a requisição para:
    *   **Ollama (IA Local):** Para perguntas de conhecimento geral, explicações, resumos, etc.
    *   **Manus (IA Externa/UiPath/Airtop.ai):** Para comandos que envolvem interação com o sistema operacional, navegador, APIs externas (como a UiPath ou Airtop.ai) ou outras ferramentas que o agente local não pode executar diretamente.
*   **Fallback Multi-Provedor:** Em caso de falha de um provedor de IA, ele tenta outros configurados (`ai_integration.py`).

### 2. 🏗️ O Motor de Inferência Local: Ollama (Local & Privado)

A base da nossa IA local não depende da nuvem, garantindo a privacidade dos dados dos pacientes.
*   **Tecnologia:** Utilizamos o **Ollama** rodando em um container Docker.
*   **Modelos:** Configurado para operar com **Llama2** ou **Mistral**, modelos de linguagem de ponta otimizados para análise de texto.
*   **Integração:** O Agente Multimodelo comunica-se via API (porta 11434) com o Ollama para processar prompts estruturados.

### 3. Classificação de Complexidade
Utilização das tabelas **NEAD, ABEMID e PPS** para definir o nível de assistência (Baixa, Média ou Alta). Isso impacta diretamente no custo operacional e no perfil do profissional alocado.

### 3. Análise de Perfil Comportamental (IA)
O sistema utiliza o Ollama para analisar conversas de WhatsApp e identificar:
- **Grau de Ansiedade da Família**
- **Expectativas de Assistência**
- **Vulnerabilidades Psicossociais**
- **Score de Risco Comportamental**

### 4. Gestão de Margens Financeiras
- **Regra de Ouro:** Margem de lucro mínima de **20%**.
- **Cálculo:** `Preço de Venda - (Preço de Compra + Custo Logístico + Complexidade)`.
- **Alertas:** Itens com margem < 20% são sinalizados em vermelho no Dashboard.

### 5. Rede de Apoio e Logística
A precificação é dinâmica baseada na proximidade de:
- Profissionais de saúde
- Farmácias e Distribuidoras
- Hospitais de retaguarda

---

### 6. 🛠️ Fluxo de Processamento (Workflow Atualizado)

#### 6.1. Integração Airtop.ai

A Airtop.ai atua como o "Módulo de Navegação Inteligente", permitindo que o Agente Multimodelo interaja com portais web complexos e dinâmicos, superando as limitações da RPA tradicional em cenários web.

*   **Autenticação:** Via API Key (`40988ea7894557c.kEI9Bg63LE6Y0c9xfLCBhpTvj0otUKfQGuKYFPJVd5`) armazenada de forma segura.
*   **Casos de Uso:** Consulta de elegibilidade dinâmica em portais de convênios, extração de tabelas de preços de fornecedores, contorno de anti-bots e CAPTCHAs.

#### 6.2. Estratégia de Redundância de Navegação (Failover)

Para garantir a resiliência máxima, o Agente Multimodelo implementará uma estratégia de failover entre diferentes ferramentas de automação web:

1.  **Tentativa 1: Airtop.ai (IA-Driven Navigation):** Primeira escolha para navegação inteligente e contorno de desafios web.
2.  **Tentativa 2: Playwright (Modern Scripted Automation):** Se a Airtop.ai falhar, o Playwright será acionado para automação estruturada e rápida em múltiplos navegadores.
3.  **Tentativa 3: Puppeteer (Chrome-Specific Fallback):** Em caso de falha do Playwright, o Puppeteer será usado para automações otimizadas para o Chrome.
4.  **Tentativa 4: Selenium (Legacy/Robust Fallback):** Última linha de defesa para portais legados ou em cenários de alta complexidade.



A Airtop.ai atua como o "Módulo de Navegação Inteligente", permitindo que o Agente Multimodelo interaja com portais web complexos e dinâmicos, superando as limitações da RPA tradicional em cenários web.

*   **Autenticação:** Via API Key (`40988ea7894557c.kEI9Bg63LE6Y0c9xfLCBhpTvj0otUKfQGuKYFPJVd5`) armazenada de forma segura.
*   **Casos de Uso:** Consulta de elegibilidade dinâmica em portais de convênios, extração de tabelas de preços de fornecedores, contorno de anti-bots e CAPTCHAs.



1.  **Captação:** O n8n recebe mensagens ou áudios e os envia para o backend Laravel.
2.  **Roteamento Inteligente:** O backend Laravel envia a requisição para o **Agente Multimodelo (Obsidian Agent)**.
3.  **Decisão da IA:** O Agente Multimodelo decide se a requisição deve ser processada pelo Ollama (local) ou por um provedor externo (como a UiPath via "Manus Bridge").
4.  **Enriquecimento/Execução:**
    *   **Ollama:** Processa a requisição e retorna uma resposta estruturada.
    *   **UiPath (via Manus Bridge):** Se a requisição for para automação estruturada, o Agente Multimodelo aciona o `UiPathService.php` no Laravel, que por sua vez dispara um processo no UiPath Orchestrator.
    *   **Airtop.ai (via Agente Multimodelo):** Se a requisição for para navegação web inteligente (ex: extração de dados de portais dinâmicos), o Agente Multimodelo fará uma chamada à API da Airtop.ai para criar uma sessão de navegador em nuvem e executar a tarefa.
    *   **Playwright/Puppeteer/Selenium (via Agente Multimodelo):** Em caso de falha da Airtop.ai, o Agente Multimodelo acionará a ferramenta de automação web apropriada (Playwright, Puppeteer ou Selenium) seguindo a estratégia de failover.
5.  **Retorno:** A resposta da IA ou o status da automação é retornado ao Laravel e, em seguida, ao frontend.

## 📂 ESTRUTURA DE ARQUIVOS CRÍTICOS

### Scripts de Automação (PowerShell)
- `IMPLEMENTACAO_TOTAL_HOSPITALLAR.ps1`: Configura Docker, Ollama e Backend.
- `INTEGRACAO_FRONTEND_HOSPITALAR.ps1`: Automatiza rotas e componentes do frontend.

### Componentes de Interface (Vue/Angular)
- `menu-captacao.vue`: Estrutura de sub-módulos (Orçamentos, Marketing, Comercial).
- `dashboard-vulnerability-margin.vue`: Visão analítica de risco e lucro.

### Documentação de Suporte
- `LOGICA_ORCAMENTO_HOSPITALAR.md`: Detalhamento das regras de negócio.
- `GUIA_INTEGRACAO_FINAL_HOSPITALAR.md`: Manual passo a passo para agentes.

---

## 🔐 PROTOCOLOS DE SEGURANÇA E AUTONOMIA
- **Proibição de Deleção:** Nenhuma deleção de arquivo ou dado sem evidência e autorização explícita.
- **Backup Perpétuo:** Sincronização contínua com o GitHub: `https://github.com/Rudson-Oliveira/projeto-2026-autonomia`.
- **Independência de Agentes:** O sistema deve ser capaz de se auto-recuperar e se auto-instalar via scripts PowerShell.

---

## 📈 ROADMAP DE EVOLUÇÃO
1. **Fase Atual:** Integração com Agente Multimodelo (Obsidian Agent) e UiPath.
2. **Próxima Fase:** Desenvolvimento de robôs UiPath específicos para faturamento e elegibilidade.
3. **Visão Futura:** Predição de desospitalização baseada em tendências clínicas.

---
**Assinado:** Manus AI - Agente de Orquestração de Conhecimento
