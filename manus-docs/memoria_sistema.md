# Memória do Projeto - Sistema Autônomo Hospitalar Saúde

## Data de Início: 17/01/2026

## Informações do Sistema

### URLs
- **Sistema DEV**: https://dev.hospitalarsaude.app.br/#/dashboard/home
- **Sistema Produção**: https://hospitalarsaude.app.br/#/dashboard/home

### Usuário Logado
- **Nome**: RUDSON ANTONIO RIBEIRO OLIVEIRA
- **Nível**: 0

### Módulos Identificados no Menu
1. Administrativo
2. Almoxarifado
3. Aplicativo
4. Atualizações do sistema
5. Auditoria
6. Recepção
7. Chat com IA
8. **Compras** (explorado)
9. Locação
10. Configurações
11. Equipamentos
12. Faturamento
13. Financeiro
14. Fiscal
15. Frota
16. Jurídico
17. Logs
18. Loja
19. Operadoras
20. **Orçamentos** (foco inicial)
21. Pacientes
22. Permissões
23. Profissionais
24. Psicologia
25. Recrutamento
26. Recursos Humanos
27. Setores
28. Tabela Preços
29. Tabelas TISS

### Versão do Sistema
- release-1.0.6

---

## Módulo de Compras - Estrutura Identificada

### Abas do Módulo
1. Pedidos em construção
2. Pedidos em andamento
3. Pedidos reprovados

### Campos da Tabela de Pedidos
- ID
- Data de emissão
- Solicitante
- Setor de origem
- Tipo da compra
- Categoria
- Paciente
- Comprador

### Ações Disponíveis
- ADICIONAR PEDIDO
- FILTROS
- LIMPAR FILTRO
- Pesquisar
- Copiar
- Editar compra

### Dados de Exemplo (Pedidos em construção)
| ID | Data | Solicitante | Setor | Tipo | Categoria | Paciente |
|----|------|-------------|-------|------|-----------|----------|
| 1431 | 18/07/2025 | RODRIGO MAIA DA SILVA | TI | Avulso | Dietas | THEREZA MARIA DOS REIS |
| 1434 | 10/11/2025 | RODRIGO MAIA DA SILVA | TI | Avulso | Consumíveis | VANDERLEIA DE SOUZA DONA |

---

## Infraestrutura Local (Screenshots do Usuário)

### Serviços Ativos (Sistema IA v3.1)
- Obsidian
- Ollama (porta 11434)
- Jan - IA Local (porta 4891)
- LM Studio - IA Local
- GPT4All - IA Local
- COMET Desktop (Perplexity)
- COMET Bridge (porta 5000)
- ngrok (URL fixa)
- Obsidian Agent (porta 5001)
- Hub Central (porta 5002)
- Vision Server (porta 5003)
- Frontend (porta 5173)
- Claude Code Terminal

### URL ngrok
- https://charmless-maureen-subadministratively.ngrok-free.dev

### Docker Containers (hospitalar_v2)
- hospitalar_redis_commander (8081:8081)
- hospitalar_redis (6379:6379)
- hospitalar_php (hospitalar_v2-app)
- hospitalar_nginx (8888:80)
- hospitalar_db (3308:3306) - MySQL 8.0
- hospitalar_angular (4205:4200) - Node 16

### Estrutura de Pastas Local
```
C:\Users\rudpa\Documents\hospitalar\hospitalar_v2\
├── hospitalar_backend/
├── hospitalar_frontend/
├── mysql_data/
├── nginx/
├── banco.sql
└── docker-compose.yaml
```

---

## Repositórios GitHub
1. https://github.com/Rudson-Oliveira/13-01-26-Sistema
2. https://github.com/Rudson-Oliveira/projeto-2026-autonomia

---

## Agentes Manus Anteriores (para análise)
1. https://manus.im/app/oFm9kmHKT9Bc6ZksdOje8M
2. https://manus.im/app/lGK7uxDk47gI3mhEuiZ59f
3. https://manus.im/app/23Sg4IrQPCkMEtHUOmM8bE
4. https://manus.im/app/09eIPbzj2RgFdDGPY77HnN

---

## Próximos Passos
1. [ ] Explorar módulo de Orçamentos
2. [ ] Analisar estrutura do código fonte via GitHub
3. [ ] Identificar endpoints da API via DevTools (F12)
4. [ ] Criar plano de implementação de IA
5. [ ] Estabelecer sistema de backup de memória no GitHub



---

## Análise do Código Fonte (17/01/2026)

### Repositório 13-01-26-Sistema

#### Arquitetura do Backend (server/)
- **Framework**: tRPC (TypeScript RPC)
- **Autenticação**: Cookies de sessão
- **Banco de Dados**: Drizzle ORM

#### Routers Principais Identificados
| Router | Função |
|--------|--------|
| `organization` | Gestão de departamentos e colaboradores |
| `knowledge` | Base de conhecimento e memória |
| `automation` | Rotinas, logs e integrações |
| `assistant` | Assistente personalizado por colaborador |
| `browser` | Automação via Airtop |
| `notifications` | Email, WhatsApp, N8N |
| `n8n` | Integração N8N |
| `integrations` | Hospitalar, UiPath, Serviços Locais |
| `ai` | Multi-Provider com Fallback |
| `local` | Ecossistema Local (via ngrok) |
| `autonomy` | Protocolo de Autonomia |
| `agents` | Integração com Agentes Locais |
| `orchestrator` | MANUS Orchestrator (Roteamento Central) |
| `health` | Health Check & Circuit Breaker |
| **`budget`** | **Motor de Orçamento Hospitalar** (FOCO) |
| `aiRouter` | Router de IA Inteligente |
| `hubCentral` | Integração com Hub Central Local |

### Budget Engine - Motor de Orçamento (FOCO PRINCIPAL)

#### Endpoints Disponíveis
1. **calculate** - Calcular orçamento completo
2. **analyzeComplexity** - Analisar complexidade do paciente (NEAD/ABEMID/PPS)
3. **calculateLogistics** - Calcular custo de logística
4. **marketAnalysis** - Análise de mercado por categoria
5. **calculateMargin** - Calcular margem recomendada
6. **validate** - Validar orçamento
7. **getTemplate** - Templates por tipo de atendimento
8. **compare** - Comparar orçamentos
9. **priceHistory** - Histórico de preços
10. **getAlerts** - Alertas de vulnerabilidade de margem
11. **simulate** - Simular cenários
12. **export** - Exportar para PDF/Excel/JSON
13. **stats** - Estatísticas do motor

#### Categorias de Orçamento
- procedures (Procedimentos)
- materials (Materiais)
- medications (Medicamentos)
- diets (Dietas)
- opme (OPME)
- professionals (Profissionais)
- equipment (Equipamentos)
- transport (Transporte)

#### Templates de Atendimento
- home_care_basic
- home_care_complex
- palliative_care
- post_surgical
- chronic_disease
- rehabilitation
- pediatric
- geriatric

#### Scores de Complexidade
- NEAD Score (0-100)
- ABEMID Score (0-100)
- PPS Score (0-100)

---

## Módulo de Orçamentos no Sistema DEV

### Estrutura Identificada
- **URL**: /dashboard/orcamentos
- **Abas**:
  - Retificações (pendentes/realizadas)
  - Painel Administrativo (dashboard analítico)

### Painel Administrativo - Métricas
- Total de orçamentos
- Valor total de orçamentos solicitados
- Orçamentos Aprovados
- Quantidade de operadoras solicitantes

### Filtros Disponíveis
- Período (Início/Fim)
- Operadora
- Status (TODOS, APROVADO, REPROVADO, RECAPTAÇÃO, AGUARDANDO)
- Modo mensal/anual

### Gráficos e Análises
- Total de operadoras solicitantes
- Orçamentos por status (Quantitativo e Monetário)
- Orçamentos por semana
- Tempo de resposta (Convênio vs Particular)
- Média de Tempo por Convênio
- Modalidades orçadas
- Origem de solicitações

### Dados de Retificações (Exemplo)
| Código | Nome | Período | Finalizado |
|--------|------|---------|------------|
| 64321 | GERALDA DE OLIVEIRA COUTINHO | 23/03/2025 | 23/03/2025 |
| 63998 | GERALDA DE OLIVEIRA COUTINHO | 11/04/2025 | 12/04/2025 |
| 63317 | PACIENTE TESTE PROD | 01/04/2025 - 30/04/2025 | 12/03/2025 |

---

## Infraestrutura Docker (hospitalar_v2)

### Containers Identificados
| Container | Imagem | Porta |
|-----------|--------|-------|
| hospitalar_redis_commander | rediscommander/redis-commander | 8081:8081 |
| hospitalar_redis | redis:7-alpine | 6379:6379 |
| hospitalar_php | hospitalar_v2-app | - |
| hospitalar_nginx | nginx:alpine | 8888:80 |
| hospitalar_db | mysql:8.0 | 3308:3306 |
| hospitalar_angular | node:16-alpine | 4205:4200 |



---

## Análise dos Agentes Manus Anteriores (17/01/2026)

### Agente 09eIPbzj2RgFdDGPY77HnN
**Título**: GitHub Links and API Preview Discussion
**Status**: Tarefa concluída

#### Principais Realizações
1. **Módulo VisionAI** implementado no Obsidian Agente v5.0
   - VisionAIModule.tsx criado
   - VisionAIModule.css criado
   - Import no App.tsx adicionado
   - Case 'visionai' adicionado

2. **Sistema de Backup** funcional com endpoints:
   - /backup
   - /restore
   - /backups

3. **Integração com COMET Bridge** via ngrok:
   - URL: https://charmless-maureen-subadministratively.ngrok-free.dev
   - Endpoints: /exec, /health

4. **Funcionalidades do VisionAI**:
   - Ações Rápidas: Ir para Pacientes, Cadastrar Paciente, Buscar Paciente, Relatório Mensal
   - Filtros por Categoria: Navegação, Automação, Dados, Relatórios
   - Histórico de Ações
   - Comando Personalizado

#### Problemas Identificados
- Escape de caracteres no COMET Bridge causou falhas
- Botão VisionAI na navegação não foi adicionado automaticamente
- Scripts PowerShell complexos falharam por sintaxe

#### Aprendizados
1. Usar scripts Base64 para evitar problemas de escape
2. Criar scripts separados ao invés de comandos inline
3. Testar cada passo antes de prosseguir
4. Salvar progresso no GitHub após cada etapa

---

## Infraestrutura de Comunicação Identificada

### COMET Bridge
- **URL ngrok**: https://charmless-maureen-subadministratively.ngrok-free.dev
- **Porta local**: 5000
- **Endpoints**:
  - `/exec` - Execução de comandos PowerShell
  - `/health` - Health check
  - `/obsidian/vault/` - Acesso ao vault Obsidian
  - `/obsidian/search` - Busca no Obsidian

### Hub Central Server v1.1
- **Porta**: 5002
- **Conectores**: obsidian, google_drive, onedrive, mysql
- **Gatilhos**: 16 registrados
  - Resumo Semanal (weekly)
  - Backup Diário (daily)
  - Limpeza de Logs (weekly)
  - Insights Diários (daily)

### Vision Server
- **Porta**: 5003
- **App**: vision_server (Flask)

### Obsidian Agent
- **Porta**: 5001

### Frontend (Vite)
- **Porta**: 5173

---

## Status do Projeto (Consolidado)

### Componentes Implementados
| Componente | Status | Descrição |
|------------|--------|-----------|
| Budget Engine | ✅ Implementado | Motor de orçamento com 13 endpoints |
| VisionAI Module | ✅ 90% | Falta botão na navegação |
| COMET Bridge | ✅ Funcional | Integração local via ngrok |
| Hub Central | ✅ Funcional | Orquestração de serviços |
| Sistema de Backup | ✅ Funcional | Backup/Restore automático |
| Docker Containers | ✅ Rodando | 6 containers ativos |

### Próximos Passos Identificados
1. [ ] Adicionar botão VisionAI na navegação
2. [ ] Integrar Budget Engine com sistema DEV
3. [ ] Implementar IA no setor de orçamentos
4. [ ] Criar sistema de memória persistente no GitHub
5. [ ] Documentar fluxos de trabalho

