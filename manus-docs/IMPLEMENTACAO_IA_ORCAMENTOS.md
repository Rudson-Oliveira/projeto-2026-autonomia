_# Plano de Implementação de IA - Setor de Orçamentos_

**Autor**: Manus AI
**Data**: 17/01/2026
**Versão**: 1.0

## 1. Objetivo

Automatizar e otimizar o processo de criação e análise de orçamentos da Hospitalar Saúde, integrando um assistente de IA ao fluxo de trabalho dos colaboradores do setor. A IA irá auxiliar na coleta de dados, cálculo de custos, análise de complexidade, sugestão de margens e identificação de riscos, utilizando o **Budget Engine** já existente.

## 2. Arquitetura da Solução

A solução consiste em criar um **Agente de Orçamentos** que irá interagir com o usuário através de uma nova interface no sistema DEV e utilizará os endpoints do `budgetRouter` para executar as tarefas.

### 2.1. Fluxo de Interação

1.  **Colaborador inicia um novo orçamento** no sistema DEV.
2.  O **Agente de Orçamentos (IA)** é ativado e solicita as informações iniciais (dados do paciente, procedimento principal).
3.  O Agente utiliza o endpoint `getTemplate` para carregar um modelo de orçamento pré-definido com base no tipo de atendimento.
4.  O Agente guia o colaborador no preenchimento dos itens, utilizando os endpoints `marketAnalysis` e `priceHistory` para sugerir custos e preços.
5.  Com os dados do paciente, o Agente utiliza o `analyzeComplexity` para definir o nível de complexidade e o `calculateLogistics` para estimar custos de transporte.
6.  O Agente utiliza o `calculateMargin` para sugerir a margem de lucro ideal.
7.  O Agente consolida todas as informações e utiliza o endpoint `calculate` para gerar o orçamento final.
8.  O Agente apresenta o orçamento ao colaborador, destacando os alertas (`getAlerts`) de margem ou risco.
9.  O colaborador pode solicitar simulações (`simulate`) de cenários alternativos.
10. Após a aprovação, o orçamento é finalizado e pode ser exportado (`export`).

## 3. Fases de Implementação

### Fase 1: Integração do Backend (2 dias)

- **Tarefa 1.1**: Garantir que o `budgetRouter` esteja acessível pelo frontend do sistema DEV.
- **Tarefa 1.2**: Criar um serviço no frontend (Angular) para se comunicar com todos os endpoints do `budgetRouter`.
- **Tarefa 1.3**: Implementar a lógica de autenticação para as chamadas ao `protectedProcedure` do tRPC.

### Fase 2: Desenvolvimento do Assistente de IA (Frontend) (5 dias)

- **Tarefa 2.1**: Desenvolver um novo componente Angular para a interface do **Agente de Orçamentos**.
- **Tarefa 2.2**: Criar um chatbot ou uma interface guiada para a interação entre o colaborador e o Agente.
- **Tarefa 2.3**: Implementar o fluxo de interação descrito na seção 2.1, chamando os serviços do backend criados na Fase 1.
- **Tarefa 2.4**: Exibir os resultados (orçamento, análises, alertas) de forma clara e intuitiva na interface.

### Fase 3: Adicionar Botão VisionAI e Finalizar (1 dia)

- **Tarefa 3.1**: Criar e executar um script PowerShell robusto (via COMET Bridge) para adicionar o botão "VisionAI" no `App.tsx` do `obsidian-agente`, resolvendo o problema de escape de caracteres.
- **Tarefa 3.2**: Testar a funcionalidade do botão e a navegação para o módulo VisionAI.

### Fase 4: Testes e Validação (2 dias)

- **Tarefa 4.1**: Realizar testes de ponta a ponta, simulando a criação de orçamentos para diferentes cenários (baixa e alta complexidade, diferentes regiões, etc.).
- **Tarefa 4.2**: Validar a precisão dos cálculos, análises e sugestões da IA.
- **Tarefa 4.3**: Coletar feedback de um usuário-chave (simulado) e realizar os ajustes necessários.

## 4. Cronograma

| Fase | Duração Estimada |
|---|---|
| Fase 1: Integração do Backend | 2 dias |
| Fase 2: Desenvolvimento do Assistente de IA | 5 dias |
| Fase 3: Adicionar Botão VisionAI | 1 dia |
| Fase 4: Testes e Validação | 2 dias |
| **Total** | **10 dias** |

## 5. Requisitos e Dependências

- Acesso contínuo ao ambiente DEV e aos repositórios GitHub.
- Disponibilidade do COMET Bridge para execução de scripts no ambiente local.
- Acesso à documentação da base de dados para entender a origem dos dados de mercado e histórico de preços.
