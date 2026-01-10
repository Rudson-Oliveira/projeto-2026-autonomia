# 🧠 BASE DE CONHECIMENTO MESTRE - PROJETO HOSPITALAR 2026
**Data de Consolidação:** 10/01/2026  
**Status:** Autonomia Total Ativada

---

## 📋 VISÃO GERAL DO PROJETO
O sistema **HospitaLar** é uma plataforma de gestão de Home Care focada no **Módulo Orçamento (Captação)**. O objetivo é atingir a "Total Autonomia" no processamento de orçamentos multimodais (WhatsApp, Áudio, Imagem) com análise inteligente de complexidade e viabilidade financeira.

---

## 🛠️ ARQUITETURA TÉCNICA
- **Backend:** Laravel (PHP) - Porta 8000
- **Frontend:** Angular/Vue - Porta 4200
- **Banco de Dados:** MySQL (Principal) e PostgreSQL (Expansão)
- **Automação:** n8n - Porta 5678
- **Inteligência Artificial:** Ollama (Llama2/Mistral) - Porta 11434
- **Infraestrutura:** Docker Compose

---

## 🧠 REGRAS DE NEGÓCIO E INTELIGÊNCIA (CORE)

### 1. Classificação de Complexidade
Utilização das tabelas **NEAD, ABEMID e PPS** para definir o nível de assistência (Baixa, Média ou Alta). Isso impacta diretamente no custo operacional e no perfil do profissional alocado.

### 2. Análise de Perfil Comportamental (IA)
O sistema utiliza o Ollama para analisar conversas de WhatsApp e identificar:
- **Grau de Ansiedade da Família**
- **Expectativas de Assistência**
- **Vulnerabilidades Psicossociais**
- **Score de Risco Comportamental**

### 3. Gestão de Margens Financeiras
- **Regra de Ouro:** Margem de lucro mínima de **20%**.
- **Cálculo:** `Preço de Venda - (Preço de Compra + Custo Logístico + Complexidade)`.
- **Alertas:** Itens com margem < 20% são sinalizados em vermelho no Dashboard.

### 4. Rede de Apoio e Logística
A precificação é dinâmica baseada na proximidade de:
- Profissionais de saúde
- Farmácias e Distribuidoras
- Hospitais de retaguarda

---

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
1. **Fase Atual:** Conclusão da integração IA e Dashboard de Vulnerabilidade.
2. **Próxima Fase:** Expansão para o Módulo de Faturamento (Farmácia Clínica).
3. **Visão Futura:** Predição de desospitalização baseada em tendências clínicas.

---
**Assinado:** Manus AI - Agente de Orquestração de Conhecimento
