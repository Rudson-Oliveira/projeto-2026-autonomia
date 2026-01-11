# ESTRATÉGIA DE INTEGRAÇÃO AIRTOP.AI - SISTEMA HOSPITALAR AUTÔNOMO

**Data:** 11 de Janeiro de 2026
**Versão:** 1.0

Este documento detalha a estratégia para integrar a plataforma Airtop.ai ao ecossistema do sistema HospitaLar, utilizando o Agente Multimodelo (Obsidian Agent) como orquestrador. A Airtop.ai complementará a UiPath e o Ollama, adicionando capacidades avançadas de navegação e interação com a web controladas por IA.

## 1. Visão Geral da Airtop.ai e seu Papel no HospitaLar

A Airtop.ai é uma plataforma de navegadores em nuvem controlados por IA, que permite a automação de ações em aplicações web de forma robusta e escalável. No contexto do HospitaLar, a Airtop.ai atuará como o **"Módulo de Navegação Inteligente"**, superando as limitações da automação robótica tradicional (RPA) em cenários web dinâmicos e complexos.

### 1.1. Complementaridade com Outras Tecnologias

*   **Ollama (IA Local):** O Ollama continua sendo o "cérebro" para análise de linguagem natural e tomada de decisões internas (perfil comportamental, vulnerabilidade, margem). A Airtop.ai será acionada pelo Agente Multimodelo com base nas decisões do Ollama.
*   **UiPath (RPA Estruturada):** A UiPath é ideal para automação de processos repetitivos e estruturados em sistemas legados (desktop, web com layouts estáveis). A Airtop.ai será utilizada para cenários onde a UiPath encontraria dificuldades, como:
    *   Navegação em portais web com layouts dinâmicos ou anti-bots.
    *   Extração de dados de sites não estruturados.
    *   Resolução de CAPTCHAs.

### 1.2. Benefícios Chave da Airtop.ai para o HospitaLar

*   **Resiliência a Mudanças de Layout:** A IA da Airtop.ai entende a estrutura da web, tornando a automação menos frágil a alterações de CSS/HTML em portais de convênios ou fornecedores.
*   **Extração de Dados Inteligente:** Capacidade de extrair informações de páginas complexas usando linguagem natural, sem a necessidade de scripts específicos para cada site.
*   **Contorno de Anti-bots e CAPTCHAs:** Recursos integrados para lidar com mecanismos de detecção de bots e resolver CAPTCHAs, garantindo acesso contínuo a informações críticas.
*   **Escalabilidade em Nuvem:** Execução de sessões de navegador em nuvem, otimizando recursos e permitindo automações em larga escala.

## 2. Estratégia de Integração com o Agente Multimodelo (Obsidian Agent)

O Agente Multimodelo (`obsidian-agente`) será o ponto central para orquestrar as interações com a Airtop.ai. Ele decidirá, com base na query do usuário ou na necessidade do sistema, quando acionar a Airtop.ai.

### 2.1. Fluxo de Integração

1.  **Requisição Inicial:** Uma requisição (ex: "Verificar elegibilidade do paciente X no portal da Unimed") chega ao backend Laravel, que a encaminha para o Agente Multimodelo.
2.  **Análise de Decisão:** O `decision_logic.py` do Agente Multimodelo analisa a requisição e identifica que ela requer navegação web inteligente (categoria `web_automation_airtop`).
3.  **Acionamento da Airtop.ai:** O `intelligent_agent.py` do Agente Multimodelo, através de um novo módulo de integração, fará uma chamada à API da Airtop.ai para:
    *   Criar uma sessão de navegador em nuvem.
    *   Instruir o navegador (via linguagem natural ou scripts Playwright/Puppeteer) a realizar a tarefa (ex: navegar até o portal, preencher formulários, extrair dados).
4.  **Processamento da Airtop.ai:** A Airtop.ai executa a tarefa no navegador em nuvem, lidando com complexidades como autenticação, proxies e anti-bots.
5.  **Retorno de Dados:** A Airtop.ai retorna os resultados (ex: status de elegibilidade, dados extraídos) para o Agente Multimodelo.
6.  **Resposta ao Laravel:** O Agente Multimodelo processa os resultados e os envia de volta ao backend Laravel, que então os apresenta ao frontend ou aciona outras ações.

### 2.2. Autenticação

A autenticação com a Airtop.ai será realizada via API Key. A chave fornecida (`40988ea7894557c.kEI9Bg63LE6Y0c9xfLCBhpTvj0otUKfQGuKYFPJVd5`) será armazenada de forma segura nas variáveis de ambiente do servidor onde o Agente Multimodelo estiver rodando (`AIRTOP_API_KEY`).

### 2.3. Integração com n8n

O link `https://portal.airtop.ai/agents` indica que a Airtop.ai possui integração nativa com agentes. O n8n poderá ser configurado para:

*   **Disparar Workflows Airtop:** Acionar diretamente tarefas na Airtop.ai com base em eventos (ex: nova mensagem no WhatsApp solicitando uma consulta web).
*   **Receber Webhooks:** A Airtop.ai pode enviar webhooks para o n8n com os resultados de suas automações, permitindo a continuação do fluxo de trabalho.

## 3. Casos de Uso Específicos no HospitaLar

*   **Consulta de Elegibilidade Dinâmica:** Navegar em portais de convênios com layouts variáveis para verificar a elegibilidade de pacientes para procedimentos específicos.
*   **Extração de Tabela de Preços de Fornecedores:** Acessar sites de distribuidores de medicamentos e materiais para obter preços atualizados, alimentando a lógica de margem de 20%.
*   **Monitoramento de Notícias do Setor:** Navegar em portais de saúde para identificar novas regulamentações ou notícias que possam impactar o Home Care.

## 4. Próximos Passos

1.  **Implementar o Módulo de Integração Airtop no Agente Multimodelo:** Criar o código Python dentro do `obsidian-agente` para fazer chamadas à API da Airtop.ai.
2.  **Atualizar o `decision_logic.py`:** Adicionar uma nova categoria de decisão para `web_automation_airtop`.
3.  **Testes de Integração:** Realizar testes para garantir que o Agente Multimodelo possa acionar a Airtop.ai e processar seus retornos corretamente.

---
