/**
 * Serviço de Análise Comportamental e Vulnerabilidade
 * Integra dados de raspagem WhatsApp com análise de IA (Ollama)
 * Gera score de vulnerabilidade e recomendações de precificação
 */

class BehavioralAnalysisService {
  constructor(ollamaEndpoint = 'http://localhost:11434') {
    this.ollamaEndpoint = ollamaEndpoint;
    this.model = 'llama2'; // Pode ser llama2, mistral, etc.
  }

  /**
   * Analisar conversa e extrair perfil comportamental
   * @param {Object} conversationData - Dados da conversa (nome, telefone, mensagens)
   * @returns {Promise<Object>} Perfil comportamental e vulnerabilidades
   */
  async analyzeConversation(conversationData) {
    try {
      const {
        clientName,
        phoneNumber,
        messages,
        familyMembers,
        previousComplaints,
        assistanceHistory
      } = conversationData;

      // Preparar prompt para análise
      const analysisPrompt = this.buildAnalysisPrompt({
        clientName,
        messages,
        familyMembers,
        previousComplaints,
        assistanceHistory
      });

      // Chamar Ollama para análise
      const response = await this.callOllama(analysisPrompt);

      // Processar resposta e extrair métricas
      const analysis = this.parseAnalysisResponse(response);

      return {
        clientName,
        phoneNumber,
        analysis,
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      console.error('Erro na análise comportamental:', error);
      throw error;
    }
  }

  /**
   * Construir prompt para análise de comportamento
   */
  buildAnalysisPrompt(data) {
    const { clientName, messages, familyMembers, previousComplaints, assistanceHistory } = data;

    return `
Você é um especialista em análise comportamental e vulnerabilidade em cuidados de saúde domiciliar.

Analise os seguintes dados do cliente e forneça uma avaliação estruturada:

CLIENTE: ${clientName}

MENSAGENS RECENTES:
${messages.map(m => `- ${m.timestamp}: ${m.text}`).join('\n')}

MEMBROS DA FAMÍLIA:
${familyMembers.map(m => `- ${m.name} (${m.relationship}): ${m.involvement}`).join('\n')}

HISTÓRICO DE RECLAMAÇÕES:
${previousComplaints.length > 0 ? previousComplaints.join('\n') : 'Nenhuma reclamação registrada'}

HISTÓRICO DE ASSISTÊNCIA:
${assistanceHistory.map(h => `- ${h.date}: ${h.service} (${h.feedback})`).join('\n')}

Por favor, forneça uma análise estruturada em JSON com os seguintes campos:

{
  "anxietyLevel": "Baixo|Médio|Alto",
  "anxietyScore": 0-100,
  "familyEngagement": "Baixo|Médio|Alto",
  "engagementScore": 0-100,
  "expectations": "descrição das expectativas",
  "vulnerabilities": ["vulnerabilidade1", "vulnerabilidade2", ...],
  "vulnerabilityRiskScore": 0-100,
  "behavioralProfile": "ansioso|colaborativo|independente|desconfiado",
  "recommendations": ["recomendação1", "recomendação2", ...],
  "pricingAdjustment": "Nenhum|Aumento de 5-10%|Aumento de 10-20%|Redução de 5%",
  "summary": "resumo executivo da análise"
}

Seja preciso e baseie-se nos dados fornecidos.
    `;
  }

  /**
   * Chamar Ollama para processar prompt
   */
  async callOllama(prompt) {
    try {
      const response = await fetch(`${this.ollamaEndpoint}/api/generate`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          model: this.model,
          prompt: prompt,
          stream: false,
          temperature: 0.7
        })
      });

      if (!response.ok) {
        throw new Error(`Ollama API error: ${response.statusText}`);
      }

      const data = await response.json();
      return data.response;
    } catch (error) {
      console.error('Erro ao chamar Ollama:', error);
      throw error;
    }
  }

  /**
   * Parsear resposta do Ollama e extrair JSON
   */
  parseAnalysisResponse(response) {
    try {
      // Extrair JSON da resposta
      const jsonMatch = response.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        throw new Error('Nenhum JSON encontrado na resposta');
      }

      const analysis = JSON.parse(jsonMatch[0]);
      return analysis;
    } catch (error) {
      console.error('Erro ao parsear resposta:', error);
      // Retornar análise padrão se falhar
      return this.getDefaultAnalysis();
    }
  }

  /**
   * Análise padrão quando Ollama não está disponível
   */
  getDefaultAnalysis() {
    return {
      anxietyLevel: 'Médio',
      anxietyScore: 50,
      familyEngagement: 'Médio',
      engagementScore: 50,
      expectations: 'Análise não disponível',
      vulnerabilities: [],
      vulnerabilityRiskScore: 50,
      behavioralProfile: 'colaborativo',
      recommendations: ['Agendar conversa com a família'],
      pricingAdjustment: 'Nenhum',
      summary: 'Análise padrão - Ollama não disponível'
    };
  }

  /**
   * Calcular score de vulnerabilidade combinado
   */
  calculateVulnerabilityScore(analysis, logisticsData, marginData) {
    const weights = {
      behavioral: 0.35,
      logistics: 0.30,
      financial: 0.35
    };

    const behavioralScore = analysis.vulnerabilityRiskScore || 50;
    const logisticsScore = this.calculateLogisticsScore(logisticsData);
    const financialScore = this.calculateFinancialScore(marginData);

    const totalScore =
      (behavioralScore * weights.behavioral) +
      (logisticsScore * weights.logistics) +
      (financialScore * weights.financial);

    return {
      totalScore: Math.round(totalScore),
      behavioralScore,
      logisticsScore,
      financialScore,
      riskLevel: this.getRiskLevel(totalScore)
    };
  }

  /**
   * Calcular score de logística
   */
  calculateLogisticsScore(logisticsData) {
    const {
      distanceToClient = 10,
      availableProfessionals = 5,
      nearbyPharmacies = 3,
      equipmentDistributors = 2
    } = logisticsData;

    // Score baseado em distância (quanto maior a distância, maior o score de risco)
    const distanceScore = Math.min((distanceToClient / 50) * 100, 100);

    // Score baseado em disponibilidade de rede de apoio
    const supportScore = Math.max(
      100 - ((availableProfessionals + nearbyPharmacies + equipmentDistributors) * 10),
      0
    );

    return (distanceScore + supportScore) / 2;
  }

  /**
   * Calcular score financeiro
   */
  calculateFinancialScore(marginData) {
    const {
      marginPercentage = 20,
      targetMargin = 20
    } = marginData;

    // Score baseado em desvio da margem alvo
    const marginDeviation = Math.abs(marginPercentage - targetMargin);
    const marginScore = Math.min((marginDeviation / 20) * 100, 100);

    // Se margem < 15%, score crítico
    if (marginPercentage < 15) {
      return 90;
    }

    // Se margem < 20%, score elevado
    if (marginPercentage < 20) {
      return 70;
    }

    return marginScore;
  }

  /**
   * Determinar nível de risco
   */
  getRiskLevel(score) {
    if (score >= 70) return 'CRÍTICO';
    if (score >= 50) return 'ALTO';
    if (score >= 30) return 'MÉDIO';
    return 'BAIXO';
  }

  /**
   * Gerar recomendações de precificação baseadas em análise
   */
  generatePricingRecommendations(analysis, currentPrice, costPrice, marginData) {
    const recommendations = [];
    const { vulnerabilityRiskScore, anxietyScore, familyEngagement } = analysis;

    // Recomendação 1: Ajuste por complexidade comportamental
    if (vulnerabilityRiskScore > 70) {
      recommendations.push({
        type: 'BEHAVIORAL_ADJUSTMENT',
        adjustment: '+10%',
        reason: 'Alta vulnerabilidade comportamental requer acompanhamento intensivo',
        newPrice: currentPrice * 1.10
      });
    }

    // Recomendação 2: Ajuste por engajamento familiar
    if (familyEngagement === 'Alto' && anxietyScore > 60) {
      recommendations.push({
        type: 'FAMILY_ENGAGEMENT',
        adjustment: '+5%',
        reason: 'Família altamente engajada mas com alta ansiedade - requer mais comunicação',
        newPrice: currentPrice * 1.05
      });
    }

    // Recomendação 3: Validar margem
    const currentMargin = ((currentPrice - costPrice) / currentPrice) * 100;
    if (currentMargin < 20) {
      recommendations.push({
        type: 'MARGIN_ALERT',
        adjustment: 'REVISAR',
        reason: `Margem atual (${currentMargin.toFixed(1)}%) abaixo do alvo de 20%`,
        suggestedPrice: costPrice / 0.80 // 20% de margem
      });
    }

    return recommendations;
  }

  /**
   * Integrar análise com dados de orçamento
   */
  async enrichBudgetData(budgetData) {
    try {
      const conversationAnalysis = await this.analyzeConversation({
        clientName: budgetData.clientName,
        phoneNumber: budgetData.phoneNumber,
        messages: budgetData.messages || [],
        familyMembers: budgetData.familyMembers || [],
        previousComplaints: budgetData.previousComplaints || [],
        assistanceHistory: budgetData.assistanceHistory || []
      });

      const vulnerabilityScore = this.calculateVulnerabilityScore(
        conversationAnalysis.analysis,
        budgetData.logistics,
        budgetData.margin
      );

      const pricingRecommendations = this.generatePricingRecommendations(
        conversationAnalysis.analysis,
        budgetData.totalPrice,
        budgetData.costPrice,
        budgetData.margin
      );

      return {
        ...budgetData,
        behavioralAnalysis: conversationAnalysis.analysis,
        vulnerabilityScore,
        pricingRecommendations,
        enrichedAt: new Date().toISOString()
      };
    } catch (error) {
      console.error('Erro ao enriquecer dados de orçamento:', error);
      return budgetData;
    }
  }
}

// Exportar para uso em Node.js ou bundlers
if (typeof module !== 'undefined' && module.exports) {
  module.exports = BehavioralAnalysisService;
}
