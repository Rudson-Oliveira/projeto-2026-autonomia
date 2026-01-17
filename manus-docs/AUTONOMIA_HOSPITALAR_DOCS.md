# Projeto 2026 - Autonomia de Sistema Hospitalar Saúde

**Autor**: Manus AI
**Data**: 17/01/2026
**Versão**: 1.0

## 1. Visão Geral do Projeto

O objetivo deste projeto é desenvolver um sistema autônomo para a Hospitalar Soluções em Saúde, integrando Inteligência Artificial no frontend, backend e banco de dados para otimizar processos, começando pelo setor de orçamentos. Cada colaborador será um assistente de IA, seguindo o organograma da empresa, e o sistema utilizará agentes locais para otimizar custos.

### 1.1. Base de Conhecimento

A base de conhecimento e aprendizado do sistema será composta por:

- Login e senha do usuário
- Documentos internos
- Interação com usuário
- Frontend e Backend
- Banco de dados
- Código fonte
- E-mail e WhatsApp
- Servidor

### 1.2. Arquitetura de Alto Nível

O sistema é composto por uma arquitetura de microserviços orquestrada pelo Hub Central, com integrações com agentes locais (COMET) e serviços de nuvem. A comunicação com o ambiente local do usuário é feita através do COMET Bridge, exposto via ngrok.

## 2. Análise do Ecossistema

### 2.1. Análise do Código Fonte

A análise do código-fonte revelou uma arquitetura robusta baseada em tRPC, Drizzle ORM e TypeScript. O componente central para o escopo inicial é o **Budget Engine**, um motor de orçamento com 13 endpoints que cobrem desde o cálculo de custos até a análise de complexidade e simulação de cenários.

#### 2.1.1. Budget Engine (Motor de Orçamento)

| Endpoint | Descrição |
|---|---|
| `calculate` | Calcular orçamento completo |
| `analyzeComplexity` | Analisar complexidade do paciente (NEAD/ABEMID/PPS) |
| `calculateLogistics` | Calcular custo de logística |
| `marketAnalysis` | Análise de mercado por categoria |
| `calculateMargin` | Calcular margem recomendada |
| `validate` | Validar orçamento |
| `getTemplate` | Obter templates por tipo de atendimento |
| `compare` | Comparar orçamentos |
| `priceHistory` | Obter histórico de preços |
| `getAlerts` | Obter alertas de vulnerabilidade de margem |
| `simulate` | Simular cenários de orçamento |
| `export` | Exportar orçamento para PDF/Excel/JSON |
| `stats` | Obter estatísticas do motor de orçamento |

### 2.2. Análise do Sistema DEV

O sistema DEV (`dev.hospitalarsaude.app.br`) possui um módulo de orçamentos (`/dashboard/orcamentos`) com um painel administrativo que exibe métricas, filtros e gráficos para análise de orçamentos. A análise do painel revelou a lógica de negócio e os principais KPIs do setor.

### 2.3. Análise dos Agentes Anteriores

A análise dos agentes Manus anteriores, especialmente o `09eIPbzj2RgFdDGPY77HnN`, revelou a implementação bem-sucedida do módulo VisionAI e do sistema de backup. No entanto, foram identificados problemas com a adição do botão VisionAI na navegação devido a limitações de escape de caracteres no COMET Bridge.

## 3. Sistema de Memória Persistente

Para garantir a continuidade e o aprendizado do sistema, foi estabelecido um sistema de memória persistente. Todas as análises, descobertas e decisões são documentadas neste arquivo e no `memoria_sistema.md`, e versionadas no repositório GitHub `projeto-2026-autonomia`.

## 4. Plano de Implementação de IA (Setor de Orçamentos)

O plano de implementação de IA para o setor de orçamentos será focado em automatizar e otimizar o processo de criação e análise de orçamentos, utilizando o Budget Engine e integrando-o com o sistema DEV.

### 4.1. Fases do Projeto

| Fase | Título | Status |
|---|---|---|
| 1 | Reconhecimento do sistema DEV e estrutura existente | ✅ Concluído |
| 2 | Clonar repositórios GitHub e analisar código fonte | ✅ Concluído |
| 3 | Analisar agentes Manus anteriores para contexto | ✅ Concluído |
| 4 | Criar sistema de memória persistente e documentação | ✅ Concluído |
| 5 | Elaborar plano de implementação de IA para orçamentos | ⏳ Em andamento |
| 6 | Reportar descobertas e próximos passos ao usuário | ⏳ Pendente |

### 4.2. Próximos Passos

1.  **Integração do Budget Engine**: Conectar o Budget Engine ao sistema DEV para permitir a criação de orçamentos via API.
2.  **Automação da Análise de Complexidade**: Utilizar o endpoint `analyzeComplexity` para classificar automaticamente a complexidade dos pacientes.
3.  **Análise de Mercado em Tempo Real**: Integrar o endpoint `marketAnalysis` para fornecer insights de mercado durante a criação do orçamento.
4.  **Otimização de Margem**: Utilizar o endpoint `calculateMargin` para sugerir a margem de lucro ideal para cada orçamento.
5.  **Interface do Assistente de IA**: Desenvolver uma interface no frontend para que o colaborador do setor de orçamentos possa interagir com o assistente de IA.

## 5. Lições Aprendidas

- **Scripts PowerShell**: Evitar comandos inline complexos e preferir scripts em arquivos separados para evitar problemas de escape.
- **Testes Incrementais**: Testar cada etapa de uma automação antes de prosseguir para a próxima.
- **Versionamento**: Salvar o progresso no GitHub após cada etapa significativa para garantir a rastreabilidade e a recuperação.
