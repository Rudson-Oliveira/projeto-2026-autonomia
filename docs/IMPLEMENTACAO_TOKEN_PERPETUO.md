# 🔑 Guia Técnico: Implementação do Token de API Perpétuo para Autonomia Total

Este guia detalha o processo de criação e configuração de um **Token de API Perpétuo** para o `MANUS_AGENT`. Este token é a "chave mestra" que permitirá ao MANUS acessar o backend do Hospitalar de forma autônoma e segura, sem a necessidade de autenticação de dois fatores (2FA) ou rotação frequente, garantindo a operação 24/7 do sistema de automação de orçamentos.

## 1. Justificativa para o Token Perpétuo

A autonomia total do MANUS exige acesso ininterrupto e sem fricção à API do sistema. Tokens de curta duração ou que exigem 2FA para renovação introduzem pontos de falha e intervenção humana, contrariando o objetivo de "zero intervenção". Um token perpétuo, quando gerenciado com segurança, é essencial para a operação de agentes autônomos em ambientes de produção.

## 2. Criação do Usuário de API Dedicado (`MANUS_AGENT`)

É fundamental que o token esteja associado a um usuário específico com permissões mínimas necessárias para as operações de automação de orçamentos. Isso garante o princípio do menor privilégio e facilita a auditoria.

### Passos para o Desenvolvedor Backend:

1.  **Criar Usuário:** No sistema de gerenciamento de usuários do backend, crie um novo usuário com o nome `MANUS_AGENT` (ou similar).
2.  **Definir Permissões:** Atribua a este usuário apenas as permissões necessárias para:
    *   `GET` (leitura) em endpoints relacionados a orçamentos (ex: `/api/budgets`, `/api/budgets/{id}`).
    *   `POST`/`PUT` (criação/atualização) em endpoints de orçamentos (ex: `/api/budgets`).
    *   `GET` (leitura) em endpoints de pacientes ou outros dados auxiliares necessários para o processamento de orçamentos.
3.  **Desativar 2FA:** Certifique-se de que a autenticação de dois fatores (2FA) esteja **desativada** para o `MANUS_AGENT`, pois ele será um usuário de máquina.

## 3. Geração do Token JWT de Longa Duração (ou Não Expirável)

O método exato para gerar um token JWT (JSON Web Token) de longa duração dependerá da sua implementação de autenticação. Abaixo estão as diretrizes gerais:

### Opção A: Configuração de Expiração (Recomendado se o sistema permitir)

Se o seu sistema usa uma biblioteca JWT que permite configurar o tempo de expiração (`exp` claim), configure-o para um período muito longo (ex: 10 anos) ou desative a expiração se a biblioteca suportar.

```javascript
// Exemplo em Node.js com 'jsonwebtoken' (apenas para ilustração)
const jwt = require('jsonwebtoken');
const payload = { userId: 'MANUS_AGENT_ID', role: 'api_agent' };
const secret = process.env.JWT_SECRET; // Sua chave secreta JWT

// Token com expiração de 10 anos (aproximadamente 315.360.000 segundos)
const token = jwt.sign(payload, secret, { expiresIn: '10y' }); 
console.log(token);
```

### Opção B: Token de API Dedicado (Se o sistema tiver um)

Alguns sistemas oferecem a funcionalidade de "API Keys" ou "Personal Access Tokens" que são projetados para acesso programático e geralmente não expiram. Se o seu backend tiver essa funcionalidade, gere um token para o `MANUS_AGENT` através dela.

## 4. Armazenamento Seguro do Token no Docker (n8n)

O token gerado deve ser armazenado como uma variável de ambiente segura no ambiente Docker do n8n. Isso evita que o token seja exposto no código-fonte ou em logs.

### Passos para Configuração no Docker Compose (ou Kubernetes):

1.  **Adicionar ao `.env`:** No arquivo `.env` do seu projeto Docker, adicione a variável:
    ```
    HOSPITALAR_API_TOKEN=seu_token_jwt_aqui
    ```
2.  **Configurar no `docker-compose.yml`:** No serviço do n8n, adicione a variável de ambiente:
    ```yaml
    services:
      n8n:
        image: n8nio/n8n
        environment:
          - HOSPITALAR_API_TOKEN=${HOSPITALAR_API_TOKEN}
          # Outras variáveis do n8n...
        # ...
    ```
3.  **Acessar no n8n:** Nos workflows do n8n, o token pode ser acessado via expressão `{{ $env.HOSPITALAR_API_TOKEN }}`.

## 5. Teste de Validação do Token

Após a criação e configuração do token, é crucial validar se ele funciona corretamente e se o `MANUS_AGENT` tem as permissões esperadas.

### Comando de Teste (Exemplo com `curl`):

```bash
curl -X GET \
  -H "Authorization: Bearer seu_token_jwt_aqui" \
  https://dev.hospitalarsaude.app.br/api/auth/me
```

**Resultado Esperado:** Uma resposta JSON contendo os dados do usuário `MANUS_AGENT`, sem erros de autenticação ou autorização.

Com este token configurado, o MANUS terá acesso contínuo e seguro à API, permitindo a execução autônoma de todas as operações de orçamentos e a implementação de futuras melhorias sem a necessidade de intervenção humana.
