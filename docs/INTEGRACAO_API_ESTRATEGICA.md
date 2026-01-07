# 🚀 Estratégia de Integração API: Autonomia Total para Orçamentos

Este documento detalha a estratégia para integrar o sistema de automação de orçamentos diretamente com o backend do Hospitalar, utilizando APIs para maximizar a autonomia, eficiência e resolutividade, minimizando a intervenção humana.

## 1. Mapeamento de Endpoints Críticos (Ambiente DEV)

Com base na auditoria do ambiente `dev.hospitalarsaude.app.br`, identificamos os seguintes endpoints que podem ser utilizados para a integração:

| Funcionalidade | Método HTTP | Endpoint (Exemplo) | Observações |
|---|---|---|---|
| **Autenticação** | `POST` | `/api/auth/login` | Requer `email` e `password`. Retorna `token` e `refresh_token`. |
| **Verificação 2FA** | `POST` | `/api/verify-2fa` | Necessário após login, se 2FA estiver ativo. |
| **Dados do Usuário** | `GET` | `/api/auth/me` | Retorna informações do usuário autenticado. |
| **Notificações** | `GET` | `/api/administrativo/demandas-notificacoes` | Pode ser usado para monitorar novas demandas de orçamento. |
| **Orçamentos (Listar)** | `GET` | `/api/budgets` | Endpoint hipotético para listar orçamentos. **A ser confirmado.** |
| **Orçamentos (Detalhes)** | `GET` | `/api/budgets/{id}` | Endpoint hipotético para obter detalhes de um orçamento específico. **A ser confirmado.** |
| **Orçamentos (Criar/Atualizar)** | `POST`/`PUT` | `/api/budgets` | Endpoint hipotético para criar ou atualizar orçamentos. **A ser confirmado.** |

**Observação:** Os endpoints de `budgets` são hipotéticos e precisam ser confirmados no backend do sistema. A análise via console não revelou endpoints diretos para orçamentos, sugerindo que a interação pode ocorrer via GraphQL ou um endpoint mais genérico.

## 2. Sugestão de Payload JSON para Ollama

Para que o Ollama extraia os dados dos orçamentos em um formato que o backend do Hospitalar possa consumir diretamente, sugerimos o seguinte payload JSON de saída:

```json
{
  "codigo_orcamento": "string",
  "nome_paciente": "string",
  "data_emissao": "YYYY-MM-DD",
  "data_validade": "YYYY-MM-DD",
  "valor_total": "number",
  "itens_orcamento": [
    {
      "descricao": "string",
      "quantidade": "number",
      "valor_unitario": "number",
      "valor_total_item": "number"
    }
  ],
  "observacoes": "string"
}
```

**Instrução para Ollama:** "Extraia as seguintes informações do documento de orçamento e formate-as como um objeto JSON, seguindo o schema fornecido. Certifique-se de que todos os campos estejam presentes e com o tipo de dado correto. Se um campo não for encontrado, retorne-o como `null` ou string vazia, conforme apropriado."

## 3. Protocolo de Segurança e Gerenciamento de Token (Autônomo)

Para garantir que o MANUS possa interagir com a API de forma autônoma e segura, sem a necessidade de intervenção humana para autenticação 2FA, propomos o seguinte protocolo:

1.  **Token de API Dedicado:** Criar um usuário de API no sistema do Hospitalar com permissões restritas apenas para as operações de orçamento (leitura e escrita).
2.  **Geração de Token de Longa Duração:** Gerar um token de acesso (ou chave de API) para este usuário que não expire ou tenha uma validade muito longa.
3.  **Armazenamento Seguro:** O token será armazenado como uma variável de ambiente segura no ambiente Docker do n8n (`N8N_API_TOKEN`) e acessado apenas pelos workflows necessários.
4.  **Rotação de Token:** Implementar um workflow no n8n que monitore a validade do token e, se necessário, solicite um novo token (se a API permitir) ou notifique o MANUS para uma rotação manual.
5.  **Monitoramento de Acesso:** Registrar todos os acessos da API em logs centralizados para auditoria e detecção de anomalias.

Este protocolo garante que o MANUS tenha acesso contínuo e seguro à API, mantendo a autonomia e a conformidade com as políticas de segurança.
