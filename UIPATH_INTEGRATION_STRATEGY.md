# 🤖 ESTRATÉGIA DE INTEGRAÇÃO UIPATH & HOSPITALAR
**Data:** 10/01/2026  
**Status:** Em Desenvolvimento

---

## 📋 SUMÁRIO EXECUTIVO

Este documento detalha a estratégia para integrar a plataforma de Automação Robótica de Processos (RPA) **UiPath** ao sistema HospitaLar. O objetivo é estender a "Autonomia Total" para processos que envolvem sistemas legados ou interfaces web complexas, como portais de convênios e sistemas de faturamento.

---

## 🎯 OBJETIVOS DA INTEGRAÇÃO

- **Automatizar Faturamento:** Reduzir erros e tempo no lançamento de guias em portais de convênios.
- **Agilizar Elegibilidade:** Verificar a cobertura de planos de saúde em tempo real.
- **Otimizar Estoque:** Sincronizar o consumo de insumos com o sistema de farmácia clínica.
- **Reduzir Custos Operacionais:** Minimizar a intervenção humana em tarefas repetitivas.

---

## 🛠️ ARQUITETURA DE INTEGRAÇÃO

### 1. Componentes Envolvidos
- **HospitaLar Backend (Laravel):** Servirá como o orquestrador, disparando os processos da UiPath.
- **UiPath Orchestrator:** A plataforma central para gerenciar, monitorar e implantar os robôs (Client ID: `4579-0379-7019-4236`).
- **UiPath Robots:** Agentes de software que executarão as tarefas automatizadas em máquinas virtuais ou físicas.
- **Sistemas Legados:** Portais de convênios, sistemas de faturamento, sistemas de estoque, etc.

### 2. Fluxo de Integração

1.  **Gatilho no HospitaLar:** Uma ação no backend do HospitaLar (ex: aprovação de orçamento, solicitação de elegibilidade) dispara uma chamada para a API do UiPath Orchestrator.
2.  **Disparo de Processo:** O Orchestrator recebe a requisição e inicia um processo de robô específico.
3.  **Execução do Robô:** O robô interage com os sistemas legados (navegadores, aplicações desktop) para realizar a tarefa (ex: preencher formulários, extrair dados).
4.  **Retorno de Status:** O robô envia o status da execução e quaisquer dados coletados de volta para o HospitaLar via webhook ou API.

### 3. Credenciais de Acesso
- **UiPath Orchestrator URL:** `https://cloud.uipath.com/hospitalarsaude`
- **Client ID (Client Credentials Flow):** `4579-0379-7019-4236`
- **Client Secret:** Será gerado no Orchestrator e armazenado de forma segura nas variáveis de ambiente do Laravel (`.env`).

---

## ⚙️ IMPLEMENTAÇÃO NO BACKEND (LARAVEL)

### 1. Configuração de Variáveis de Ambiente
Adicionar ao arquivo `.env` do Laravel:

```dotenv
UIPATH_ORCHESTRATOR_URL="https://cloud.uipath.com/hospitalarsaude"
UIPATH_CLIENT_ID="4579-0379-7019-4236"
UIPATH_CLIENT_SECRET="your_uipath_client_secret"
UIPATH_TENANT_NAME="hospitalarsaude" # Ajustar conforme o nome do seu tenant
UIPATH_ACCOUNT_NAME="hospitalarsaude" # Ajustar conforme o nome da sua conta
```

### 2. Serviço de Integração UiPath
Criar um serviço Laravel (`UiPathService.php`) para encapsular a lógica de autenticação e chamada da API do Orchestrator. Este serviço será responsável por:
- Obter o token de acesso OAuth2.
- Listar processos disponíveis.
- Disparar processos com parâmetros de entrada.
- Consultar o status de jobs.

### 3. Endpoints API no Laravel
Expor endpoints no Laravel para que o frontend ou outros serviços possam disparar processos da UiPath, por exemplo:
- `POST /api/uipath/start-process`
- `GET /api/uipath/job-status/{jobId}`

---

## 🤖 DESENVOLVIMENTO DE ROBÔS (UIPATH STUDIO)

Serão desenvolvidos robôs específicos para cada processo de negócio, como:
- **`FaturamentoGuiaConvenio`:** Automatiza o preenchimento de guias em portais.
- **`ConsultaElegibilidade`:** Realiza a consulta de elegibilidade do paciente.
- **`SincronizacaoEstoque`:** Atualiza o sistema de estoque com base nos orçamentos.

Cada robô receberá dados de entrada do HospitaLar (via Orchestrator) e retornará o resultado da execução.

---

## 📈 MONITORAMENTO E LOGGING

- Utilizar os recursos de logging do UiPath Orchestrator para monitorar a execução dos robôs.
- Implementar logging detalhado no backend do Laravel para registrar as chamadas à API da UiPath e os retornos dos robôs.

---

## ✅ PRÓXIMOS PASSOS

1.  **Gerar Client Secret:** No UiPath Orchestrator, gerar o Client Secret para o Client ID fornecido.
2.  **Desenvolver `UiPathService.php`:** Implementar o serviço Laravel para interação com a API do Orchestrator.
3.  **Criar Robôs:** Desenvolver os robôs no UiPath Studio para os processos de negócio definidos.
4.  **Testes:** Realizar testes de integração completos entre o HospitaLar e a UiPath.

---

**Assinado:** Manus AI - Agente de Automação  
**Data:** 10/01/2026
