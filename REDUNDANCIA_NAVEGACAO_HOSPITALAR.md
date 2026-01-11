# ESTRATÉGIA DE REDUNDÂNCIA E RESILIÊNCIA DE NAVEGAÇÃO - SISTEMA HOSPITALAR AUTÔNOMO

**Data:** 11 de Janeiro de 2026
**Versão:** 1.0

Este documento detalha a estratégia para implementar redundância e resiliência na automação de navegação web do sistema HospitaLar. O objetivo é garantir que, mesmo diante de falhas ou bloqueios em um método de automação, o sistema possa alternar para outro, mantendo a operação contínua e autônoma.

## 1. A Importância da Redundância na Automação

Em um ambiente crítico como o Home Care, a falha na automação de tarefas essenciais (como consulta de elegibilidade em portais de convênios ou faturamento) pode ter impactos significativos. A redundância garante que o sistema não dependa de um único ponto de falha, aumentando a robustez e a confiabilidade da "Autonomia Total".

## 2. Ferramentas de Automação Web para Redundância

Para alcançar essa resiliência, o HospitaLar integrará e orquestrará múltiplas ferramentas de automação web, cada uma com suas características e vantagens específicas:

### 2.1. Airtop.ai (Navegação Inteligente com IA)

*   **Perfil:** Plataforma de navegadores em nuvem controlados por IA.
*   **Papel no HospitaLar:** Primeira linha de defesa para navegação em portais complexos, dinâmicos e com mecanismos anti-bot. Utiliza IA para "entender" a página e interagir de forma mais humana.
*   **Vantagem Estratégica:** Resiliência a mudanças de layout, extração de dados não estruturados, contorno de CAPTCHAs e escalabilidade em nuvem.

### 2.2. Playwright (Multi-Browser e Rápido)

*   **Perfil:** Ferramenta de automação moderna e de alto desempenho, desenvolvida pela Microsoft, com suporte a múltiplos navegadores (Chromium, Firefox, Webkit).
*   **Papel no HospitaLar:** Segunda linha de defesa e redundância principal para automação estruturada. Ideal para cenários onde a Airtop.ai pode ser excessiva ou para automações que exigem maior controle de script.
*   **Vantagem Estratégica:** Velocidade, confiabilidade, suporte a múltiplos navegadores com uma única API, capacidade de simular diferentes dispositivos e geolocalizações.

### 2.3. Puppeteer (Especialista em Chrome)

*   **Perfil:** Biblioteca Node.js que fornece uma API de alto nível para controlar o Chrome ou Chromium via protocolo DevTools.
*   **Papel no HospitaLar:** Plano de contingência específico para ambientes baseados em Chromium. Pode ser acionado se o Playwright encontrar problemas específicos com o Firefox ou Webkit, ou para tarefas que exigem a leveza e otimização do Puppeteer.
*   **Vantagem Estratégica:** Leveza, otimização para o ecossistema Chrome, ideal para scraping rápido e automações que se beneficiam da integração direta com o DevTools.

### 2.4. Selenium (Clássico e Robusto)

*   **Perfil:** A ferramenta de automação web mais antiga e amplamente utilizada, com suporte a uma vasta gama de navegadores e linguagens de programação.
*   **Papel no HospitaLar:** Última linha de defesa para garantir a automação em portais de convênios muito antigos ou em ambientes onde as ferramentas mais modernas falham. Atua como um "plano B" para cenários de alta complexidade ou legados.
*   **Vantagem Estratégica:** Ampla compatibilidade com navegadores e sistemas operacionais, grande comunidade e robustez comprovada em cenários desafiadores.

## 3. Estratégia de Failover (Escala de Tentativas)

O Agente Multimodelo (Obsidian Agent) será o responsável por orquestrar a sequência de tentativas, garantindo que a tarefa seja concluída mesmo diante de falhas:

1.  **Tentativa 1: Airtop.ai (IA-Driven Navigation):** O Agente Multimodelo tentará primeiro executar a tarefa de navegação web usando a Airtop.ai, aproveitando sua inteligência e resiliência a mudanças de layout.
2.  **Tentativa 2: Playwright (Modern Scripted Automation):** Se a Airtop.ai falhar ou não for a ferramenta mais adequada para a tarefa específica, o Agente Multimodelo tentará executar a automação usando scripts Playwright.
3.  **Tentativa 3: Puppeteer (Chrome-Specific Fallback):** Em caso de falha do Playwright (especialmente em cenários não-Chromium), o Agente Multimodelo pode tentar a automação com Puppeteer, focando na otimização do Chrome.
4.  **Tentativa 4: Selenium (Legacy/Robust Fallback):** Como última opção, se todas as tentativas anteriores falharem, o Agente Multimodelo acionará scripts Selenium para tentar completar a tarefa, garantindo a máxima compatibilidade.

## 4. Implementação no Agente Multimodelo (Obsidian Agent)

Para suportar essa estratégia, o Agente Multimodelo precisará de:

*   **Módulos de Integração:** Novos módulos Python para interagir com as APIs do Playwright, Puppeteer e Selenium.
*   **Lógica de Decisão (`decision_logic.py`):** Atualização para incluir a priorização e a sequência de failover entre as ferramentas de navegação.
*   **Tratamento de Erros:** Mecanismos robustos de logging e retry para registrar falhas e alternar entre as ferramentas de forma inteligente.

## 5. Próximos Passos

1.  **Desenvolver Módulos de Integração:** Criar os wrappers Python para Playwright, Puppeteer e Selenium dentro do `obsidian-agente`.
2.  **Atualizar `decision_logic.py`:** Implementar a lógica de failover e priorização das ferramentas de navegação.
3.  **Testes de Resiliência:** Realizar testes exaustivos para validar a capacidade do sistema de alternar entre as ferramentas em caso de falha.

---
