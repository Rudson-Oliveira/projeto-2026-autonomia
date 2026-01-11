# ESTRATÉGIA DE PREENCHIMENTO INTELIGENTE DE FORMULÁRIOS VIA AIRTOP.AI - SISTEMA HOSPITALAR AUTÔNOMO

**Data:** 11 de Janeiro de 2026
**Versão:** 1.0

Este documento detalha a estratégia para integrar a API de Preenchimento de Formulários (Form Filling API) da Airtop.ai ao sistema HospitaLar. O objetivo é automatizar o preenchimento de guias de convênios e outros formulários web complexos de forma inteligente e resiliente, superando as limitações da RPA tradicional.

## 1. O Desafio do Preenchimento de Formulários em Portais de Convênios

O preenchimento manual de guias e formulários em portais de convênios é uma tarefa repetitiva, demorada e propensa a erros. As ferramentas de RPA tradicionais (como UiPath) podem ser frágeis a mudanças de layout, exigindo manutenção constante. A Airtop.ai, com sua abordagem baseada em IA, oferece uma solução robusta para este problema.

## 2. Como a Airtop.ai Form Filling API Funciona

A Form Filling API da Airtop.ai utiliza inteligência artificial para analisar a estrutura de um formulário web e mapear dados fornecidos em linguagem natural para os campos correspondentes. O processo ocorre em duas etapas:

1.  **Análise da Página:** A API analisa a página para entender a estrutura dos elementos do formulário.
2.  **Preenchimento Inteligente:** Os dados fornecidos (`customData`) são mapeados para os elementos do formulário com base na análise da página e na descrição dos dados.

## 3. Vantagens Estratégicas para o HospitaLar

A integração da Form Filling API da Airtop.ai trará as seguintes vantagens para o HospitaLar:

*   **Resiliência a Mudanças de Layout:** A IA da Airtop.ai é capaz de se adaptar a alterações no layout dos formulários, encontrando os campos corretos mesmo que suas posições ou IDs mudem.
*   **Velocidade e Eficiência:** O preenchimento é realizado de forma automatizada e rápida, reduzindo o tempo gasto em tarefas administrativas.
*   **Redução de Erros:** A automação inteligente minimiza a ocorrência de erros humanos no preenchimento de dados.
*   **Interação Semântica:** Permite que o sistema forneça dados em um formato mais natural e descritivo, facilitando a integração e manutenção.

## 4. Estrutura de Dados para `customData`

Para utilizar a Form Filling API, o HospitaLar precisará estruturar os dados do orçamento de forma que a IA da Airtop.ai possa compreendê-los e mapeá-los corretamente. Recomenda-se um formato de texto natural, com pares de chave-valor ou descrições claras.

**Exemplo de `customData` para uma guia de convênio:**

```
Nome do Paciente: [Nome do Paciente]
CPF do Paciente: [CPF do Paciente]
Número da Carteirinha do Convênio: [Número da Carteirinha]
Nome do Convênio: [Nome do Convênio]
Tipo de Procedimento: [Tipo de Procedimento (ex: Home Care 24h)]
Data de Início do Atendimento: [Data de Início]
Data de Término do Atendimento: [Data de Término]
Nome do Médico Solicitante: [Nome do Médico]
CRM do Médico Solicitante: [CRM do Médico]
```

O Agente Multimodelo será responsável por converter os dados do orçamento do HospitaLar para este formato de `customData` antes de enviar a requisição para a Airtop.ai.

## 5. Fluxo de Integração no HospitaLar

1.  **Geração do Orçamento:** O backend Laravel gera um orçamento completo, incluindo todos os dados necessários para o preenchimento da guia.
2.  **Requisição ao Agente Multimodelo:** O Laravel envia uma requisição ao Agente Multimodelo (Obsidian Agent) com a URL do formulário e os dados do orçamento.
3.  **Preparação do `customData`:** O Agente Multimodelo formata os dados do orçamento para o formato `customData` esperado pela Airtop.ai.
4.  **Criação de Sessão Airtop.ai:** O Agente Multimodelo chama a API da Airtop.ai para criar uma nova sessão de navegador e carregar a URL do formulário.
5.  **Preenchimento do Formulário:** O Agente Multimodelo chama a Form Filling API da Airtop.ai, passando o `sessionId`, `windowId` e o `customData` preparado.
6.  **Submissão (Opcional):** Após o preenchimento, o Agente Multimodelo pode instruir a Airtop.ai a submeter o formulário ou realizar outras ações necessárias.
7.  **Retorno:** A Airtop.ai retorna o status do preenchimento e quaisquer informações relevantes ao Agente Multimodelo, que as repassa ao Laravel.

## 6. Próximos Passos

1.  **Atualizar Agente Multimodelo:** Implementar a lógica de formatação de dados e a chamada à Form Filling API da Airtop.ai no Agente Multimodelo.
2.  **Desenvolver Templates de `customData`:** Criar templates específicos para os formulários dos principais convênios (Unimed, Bradesco, etc.).
3.  **Testes de Integração:** Realizar testes exaustivos para validar o preenchimento automático em diferentes portais de convênios.

---
