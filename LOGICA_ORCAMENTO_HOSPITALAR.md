# 🧠 INTELIGÊNCIA DE NEGÓCIO: MÓDULO ORÇAMENTO
**Data:** 10/01/2026

## 📥 1. ENTRADAS MULTIMODAIS
O sistema deve aceitar:
- **Áudio/Voz:** Transcrição via agentes.
- **Imagem/Receituário:** OCR e extração de itens.
- **WhatsApp/E-mail:** Captura automática via n8n.

## ⚙️ 2. PROCESSAMENTO (MOTOR DE CÁLCULO)
- **Referência:** Plano Terapêutico (Define a assistência).
- **Tabelas:** Cruzamento com Convênios e Particular.
- **Categorias Obrigatórias:** Procedimentos, Materiais, Medicamentos, Dietas, OPME.

## 🌍 3. ANÁLISE DE MERCADO (SEM TABELA)
Caso não exista tabela pré-definida, o agente de IA deve analisar:
1. **Logística:** Distância e acesso à localidade.
2. **Mercado:** Preço final ao consumidor e concorrência.
3. **Realidade:** Viabilidade da assistência no local.

---
**Assinado:** Manus AI (Agente de Orquestração)

## 🏥 4. CLASSIFICAÇÃO DE COMPLEXIDADE
O sistema deve utilizar as tabelas de referência:
- **NEAD / ABEMID / PPS:** Para definir se o atendimento é de Baixa, Média ou Alta Complexidade.
- **Impacto:** Define o perfil do profissional e a frequência de visitas.

## 📍 5. REDE DE APOIO E LOGÍSTICA
A precificação deve considerar a "Lei da Oferta e Procura" baseada na localização:
- **Profissionais:** Proximidade de Clínicas, Hospitais e Postos de Saúde.
- **Suprimentos:** Proximidade de Farmácias, Distribuidoras e Lojas de Equipamentos Médicos.

## 💊 6. FARMÁCIA CLÍNICA E FATURAMENTO
- **Prescrição Medicamentosa:** É a base do faturamento.
- **CoControle: O que nasce no orçamento (Medicamentos, Dietas, Sondas) deve ser rastreável até o faturamento final.

## 7. DIMENSÃO HUMANA E FINANCEIRA

### 7.1. Análise de Perfil Comportamental e Vulnerabilidade Familiar
O sistema deve processar dados de raspagem (e.g., WhatsApp) para identificar:
- **Familiares:** Quem são os principais contatos e seu grau de envolvimento.
- **Tendências de Assistência:** Preferências e histórico de cuidados.
- **Expectativas:** O que a família espera do serviço, para evitar desalinhamentos que possam gerar custos adicionais ou insatisfação.
- **Perfil Comportamental:** Análise de sentimentos e padrões de comunicação para identificar potenciais vulnerabilidades que possam impactar a adesão ao tratamento ou gerar demandas extras.

### 7.2. Gestão de Margens e Análise de Custos
Para cada item do orçamento, o sistema deve considerar:
- **Preço Atual:** Preço de venda ao cliente.
- **Preço de Compra:** Custo do item para a HospitaLar.
- **Margem de Lucro:** Calcular a margem de lucro esperada (idealmente 20%).
- **Alerta de Vulnerabilidade:** Se a margem de lucro cair abaixo de um limite pré-definido (e.g., 20%) devido a custos logísticos, complexidade do caso ou outros fatores, o sistema deve emitir um alerta visual (e.g., item em vermelho no Dashboard).
- **Rede de Apoio:** A análise da rede de apoio (profissionais e suprimentos) deve ser integrada à precificação para identificar oportunidades de otimização de custos e garantir a sustentabilidade da margem.

