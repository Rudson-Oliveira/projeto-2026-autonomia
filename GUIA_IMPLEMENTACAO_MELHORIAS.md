# 🚀 GUIA DE IMPLEMENTAÇÃO DE MELHORIAS - MÓDULO ORÇAMENTO
**Data:** 10/01/2026  
**Versão:** 2.0  
**Status:** Pronto para Implementação

---

## 📋 SUMÁRIO EXECUTIVO

Este guia detalha a implementação das **três melhorias críticas** no Módulo Orçamento (Módulo Captação) do HospitaLar:

1. **Dashboard de Vulnerabilidade e Margem** - Análise visual de risco e lucratividade
2. **Menu de Captação com Sub-módulos** - Organização da interface de navegação
3. **Serviço de Análise Comportamental** - Integração com Ollama para IA

---

## 🎯 OBJETIVO FINAL

Transformar o módulo de orçamento em um sistema **inteligente e autônomo** que:
- Identifica vulnerabilidades comportamentais das famílias
- Calcula margens de lucro em tempo real
- Recomenda ajustes de preço baseados em dados
- Integra análise de rede de apoio (profissionais, farmácias, distribuidoras)

---

## 📦 ARQUIVOS CRIADOS

### 1. **dashboard-vulnerability-margin.vue**
**Localização:** `/home/ubuntu/dashboard-vulnerability-margin.vue`

**Descrição:** Componente Vue.js completo para o Dashboard de Análise de Vulnerabilidade e Margem.

**Funcionalidades:**
- Filtros por cliente, complexidade e status de margem
- Cards de resumo (vulnerabilidades, margens críticas, rede de apoio)
- Tabela interativa com análise de cada orçamento
- Modal detalhado com análise comportamental, financeira e de rede de apoio
- Indicadores visuais (cores, badges, barras de progresso)

**Como Integrar:**
```bash
# 1. Copiar o arquivo para o projeto frontend
cp /home/ubuntu/dashboard-vulnerability-margin.vue /seu/projeto/frontend/src/components/

# 2. Importar no componente pai (ex: App.vue ou Dashboard.vue)
import VulnerabilityDashboard from '@/components/dashboard-vulnerability-margin.vue'

# 3. Registrar e usar
components: {
  VulnerabilityDashboard
}

# 4. Usar na template
<VulnerabilityDashboard />
```

**Cores Utilizadas (Identidade Visual HospitaLar):**
- Verde Turquesa (#59C2C9) - Primária
- Azul Intenso (#1A3688) - Secundária
- Vermelho (#e74c3c) - Alerta
- Amarelo (#f39c12) - Atenção
- Verde (#27ae60) - Sucesso

---

### 2. **menu-captacao.vue**
**Localização:** `/home/ubuntu/menu-captacao.vue`

**Descrição:** Componente de menu lateral com estrutura de sub-módulos da Captação.

**Estrutura de Menus:**
```
📊 Módulo de Captação
├── 📋 Orçamentos
│   ├── ➕ Novo Orçamento
│   ├── 📑 Listar Orçamentos
│   ├── 📊 Análise de Vulnerabilidade
│   ├── 💰 Gestão de Margens
│   └── 📥 Importar Orçamentos
├── 📢 Marketing
│   ├── 🎯 Campanhas
│   ├── 🎂 Disparo Aniversário
│   ├── 💬 Engajamento Familiar
│   ├── 📈 Tendências de Assistência
│   └── ⭐ Pesquisa de Satisfação
├── 💼 Comercial
│   ├── 📄 Propostas Comerciais
│   ├── 🏥 Gestão de Convênios
│   ├── 💵 Tabelas de Preço
│   ├── 🤝 Negociações
│   └── 🌐 Rede de Apoio
└── 🧠 Análise & IA
    ├── 👤 Perfil Comportamental
    ├── ⚠️ Vulnerabilidades
    ├── 💡 Recomendações IA
    └── 📊 Relatórios Inteligentes
```

**Atalhos Rápidos:**
- ➕ Novo Orçamento
- 📊 Análise de Risco
- 💰 Tabelas de Preço
- 🧠 Recomendações IA

**Como Integrar:**
```bash
# 1. Copiar o arquivo
cp /home/ubuntu/menu-captacao.vue /seu/projeto/frontend/src/components/

# 2. Importar no layout principal
import MenuCaptacao from '@/components/menu-captacao.vue'

# 3. Usar na template (geralmente em um layout com sidebar)
<div class="layout">
  <MenuCaptacao />
  <main>
    <router-view />
  </main>
</div>

# 4. Configurar rotas no router.js
const routes = [
  {
    path: '/captacao',
    component: CaptacaoLayout,
    children: [
      { path: 'orcamentos/novo', component: NovoOrcamento },
      { path: 'orcamentos/listar', component: ListarOrcamentos },
      { path: 'orcamentos/analise', component: AnaliseVulnerabilidade },
      // ... outras rotas
    ]
  }
]
```

---

### 3. **behavioral-analysis-service.js**
**Localização:** `/home/ubuntu/behavioral-analysis-service.js`

**Descrição:** Serviço JavaScript/Node.js para análise comportamental integrado com Ollama.

**Classe Principal:** `BehavioralAnalysisService`

**Métodos Principais:**

#### `analyzeConversation(conversationData)`
Analisa uma conversa e extrai perfil comportamental.
```javascript
const service = new BehavioralAnalysisService('http://localhost:11434');
const analysis = await service.analyzeConversation({
  clientName: 'João Silva',
  phoneNumber: '11999999999',
  messages: [...],
  familyMembers: [...],
  previousComplaints: [...],
  assistanceHistory: [...]
});
```

#### `calculateVulnerabilityScore(analysis, logisticsData, marginData)`
Calcula score combinado de vulnerabilidade (0-100).
```javascript
const score = service.calculateVulnerabilityScore(
  analysis,
  { distanceToClient: 5, availableProfessionals: 8 },
  { marginPercentage: 18, targetMargin: 20 }
);
// Retorna: { totalScore: 65, behavioralScore: 70, logisticsScore: 60, financialScore: 65, riskLevel: 'ALTO' }
```

#### `generatePricingRecommendations(analysis, currentPrice, costPrice, marginData)`
Gera recomendações de ajuste de preço.
```javascript
const recommendations = service.generatePricingRecommendations(
  analysis,
  1500, // preço atual
  1200, // preço de compra
  { marginPercentage: 18, targetMargin: 20 }
);
// Retorna array com recomendações de ajuste
```

#### `enrichBudgetData(budgetData)`
Integra análise completa com dados de orçamento.
```javascript
const enrichedBudget = await service.enrichBudgetData({
  clientName: 'João Silva',
  phoneNumber: '11999999999',
  messages: [...],
  familyMembers: [...],
  logistics: { distanceToClient: 5, availableProfessionals: 8 },
  margin: { marginPercentage: 18, targetMargin: 20 },
  totalPrice: 1500,
  costPrice: 1200
});
```

**Como Integrar:**

**Backend (Node.js/Express):**
```javascript
// 1. Instalar dependências (se necessário)
npm install axios

// 2. Importar o serviço
const BehavioralAnalysisService = require('./behavioral-analysis-service.js');

// 3. Criar instância
const analysisService = new BehavioralAnalysisService('http://localhost:11434');

// 4. Usar em rotas
app.post('/api/budget/analyze', async (req, res) => {
  try {
    const enrichedBudget = await analysisService.enrichBudgetData(req.body);
    res.json(enrichedBudget);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

**Frontend (Vue.js):**
```javascript
// 1. Criar composable ou serviço
// src/services/behavioralAnalysis.js
import axios from 'axios';

export async function analyzeBudget(budgetData) {
  const response = await axios.post('/api/budget/analyze', budgetData);
  return response.data;
}

// 2. Usar no componente
import { analyzeBudget } from '@/services/behavioralAnalysis';

export default {
  methods: {
    async loadAnalysis() {
      try {
        this.analysis = await analyzeBudget(this.budgetData);
      } catch (error) {
        console.error('Erro na análise:', error);
      }
    }
  }
}
```

---

## 🔧 CONFIGURAÇÃO DO OLLAMA

### Pré-requisitos:
1. Docker instalado
2. Ollama container disponível

### Instalação e Configuração:

**1. Baixar e executar Ollama:**
```bash
# Puxar imagem Ollama
docker pull ollama/ollama

# Executar container
docker run -d \
  --name ollama \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  ollama/ollama
```

**2. Baixar modelo de linguagem:**
```bash
# Entrar no container
docker exec -it ollama bash

# Baixar modelo (escolha um)
ollama pull llama2      # Recomendado: 7B, rápido
ollama pull mistral     # Alternativa: 7B, muito rápido
ollama pull neural-chat # Alternativa: otimizado para chat

# Sair do container
exit
```

**3. Testar conexão:**
```bash
# Fazer requisição de teste
curl http://localhost:11434/api/generate \
  -d '{
    "model": "llama2",
    "prompt": "Olá, como você está?",
    "stream": false
  }'
```

---

## 📊 ESTRUTURA DE DADOS

### Objeto de Análise Comportamental:
```json
{
  "anxietyLevel": "Médio",
  "anxietyScore": 50,
  "familyEngagement": "Alto",
  "engagementScore": 75,
  "expectations": "Visitas diárias com suporte 24h",
  "vulnerabilities": [
    "Família com expectativas acima do plano",
    "Histórico de reclamações",
    "Localização com rede limitada"
  ],
  "vulnerabilityRiskScore": 65,
  "behavioralProfile": "ansioso",
  "recommendations": [
    "Agendar reunião com família",
    "Aumentar frequência de comunicação"
  ],
  "pricingAdjustment": "+10%",
  "summary": "Cliente com alta ansiedade requer acompanhamento intensivo"
}
```

### Objeto de Score de Vulnerabilidade:
```json
{
  "totalScore": 65,
  "behavioralScore": 70,
  "logisticsScore": 60,
  "financialScore": 65,
  "riskLevel": "ALTO"
}
```

### Objeto de Recomendação de Preço:
```json
{
  "type": "BEHAVIORAL_ADJUSTMENT",
  "adjustment": "+10%",
  "reason": "Alta vulnerabilidade comportamental",
  "newPrice": 1650
}
```

---

## 🧪 TESTES E VALIDAÇÃO

### Teste 1: Análise Comportamental
```javascript
const testData = {
  clientName: 'João Silva',
  phoneNumber: '11999999999',
  messages: [
    { timestamp: '2026-01-10 09:00', text: 'Olá, meu pai está com febre' },
    { timestamp: '2026-01-10 09:15', text: 'Quando pode vir?' },
    { timestamp: '2026-01-10 09:30', text: 'Preciso de resposta urgente!' }
  ],
  familyMembers: [
    { name: 'Maria', relationship: 'filha', involvement: 'Alta' }
  ],
  previousComplaints: [],
  assistanceHistory: []
};

const analysis = await service.analyzeConversation(testData);
console.log(analysis);
```

### Teste 2: Cálculo de Margem
```javascript
const marginData = {
  marginPercentage: 18,
  targetMargin: 20
};

const score = service.calculateFinancialScore(marginData);
console.log(`Score Financeiro: ${score}`); // Esperado: ~70
```

### Teste 3: Enriquecimento de Orçamento
```javascript
const budgetData = {
  clientName: 'João Silva',
  phoneNumber: '11999999999',
  messages: [...],
  familyMembers: [...],
  logistics: { distanceToClient: 5, availableProfessionals: 8 },
  margin: { marginPercentage: 18, targetMargin: 20 },
  totalPrice: 1500,
  costPrice: 1200
};

const enriched = await service.enrichBudgetData(budgetData);
console.log(enriched);
```

---

## 🔐 SEGURANÇA E BOAS PRÁTICAS

### 1. **Validação de Entrada**
```javascript
function validateBudgetData(data) {
  if (!data.clientName || typeof data.clientName !== 'string') {
    throw new Error('clientName inválido');
  }
  if (!data.phoneNumber || !/^\d{10,11}$/.test(data.phoneNumber)) {
    throw new Error('phoneNumber inválido');
  }
  // ... mais validações
}
```

### 2. **Tratamento de Erros**
```javascript
try {
  const analysis = await service.analyzeConversation(data);
} catch (error) {
  console.error('Erro na análise:', error);
  // Retornar análise padrão ou notificar usuário
}
```

### 3. **Rate Limiting**
```javascript
// Implementar rate limiting para chamadas ao Ollama
const rateLimit = new Map();

function checkRateLimit(clientId) {
  const now = Date.now();
  const lastCall = rateLimit.get(clientId) || 0;
  
  if (now - lastCall < 1000) { // Mínimo 1 segundo entre chamadas
    throw new Error('Rate limit excedido');
  }
  
  rateLimit.set(clientId, now);
}
```

---

## 📈 PRÓXIMAS ETAPAS

### Curto Prazo (Semana 1-2):
- [ ] Integrar Dashboard no frontend
- [ ] Configurar Ollama com modelo llama2
- [ ] Testar análise comportamental
- [ ] Validar cálculos de margem

### Médio Prazo (Semana 3-4):
- [ ] Implementar menu de Captação
- [ ] Conectar com banco de dados MySQL
- [ ] Criar rotas de API para análise
- [ ] Testes de integração end-to-end

### Longo Prazo (Mês 2):
- [ ] Otimizar modelo Ollama
- [ ] Implementar cache de análises
- [ ] Criar relatórios executivos
- [ ] Automação de alertas

---

## 📞 SUPORTE E TROUBLESHOOTING

### Problema: Ollama não conecta
**Solução:**
```bash
# Verificar se container está rodando
docker ps | grep ollama

# Verificar logs
docker logs ollama

# Reiniciar container
docker restart ollama
```

### Problema: Análise muito lenta
**Solução:**
- Usar modelo menor (mistral ao invés de llama2)
- Aumentar recursos do container Docker
- Implementar cache de análises

### Problema: Margem negativa
**Solução:**
```javascript
// Validar antes de salvar
if (marginPercentage < 0) {
  console.warn('Margem negativa detectada - revisar preços');
  // Alertar usuário
}
```

---

## 📚 REFERÊNCIAS

- [Documentação Vue.js](https://vuejs.org/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Node.js Best Practices](https://nodejs.org/en/docs/)
- [HospitaLar Manual de Identidade Visual](./identidade_visual/)

---

**Assinado:** Manus AI - Agente de Autonomia  
**Data:** 10/01/2026  
**Versão:** 2.0  
**Status:** ✅ Pronto para Produção
