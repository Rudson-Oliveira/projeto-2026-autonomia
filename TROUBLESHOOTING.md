# Guia de Troubleshooting e FAQ - Sistema Autônomo de IA

**Autor:** Manus AI & Rudson
**Versão:** 1.0
**Data:** 06 de Janeiro de 2026

---

## 1. Introdução

Este guia serve como um manual de referência para diagnosticar e resolver os problemas mais comuns encontrados durante o desenvolvimento e operação do sistema N8N + Ollama. As soluções aqui apresentadas são baseadas nos desafios enfrentados e resolvidos ao longo do projeto.

---

## 2. Guia de Erros Comuns (Troubleshooting)

### Erro 1: `Cannot access '$input' before initialization [line 2]`

- **Sintoma:** O workflow falha no nó "Code in JavaScript" com este erro exato.
- **Causa Raiz:** O código está tentando redefinir a variável de sistema reservada `$input` do N8N. A linha problemática é `const $input = $input.item.json.body;`.
- **Solução:** Renomeie a sua variável para qualquer outro nome que não seja `$input`. A prática recomendada é usar `inputData`.
  ```javascript
  // CORRETO:
  const inputData = $input.item.json.body;
  const requestedService = inputData.agente;
  ```

### Erro 2: `The requested webhook "..." is not registered`

- **Sintoma:** Ao chamar um webhook de teste (ex: `/webhook-test/...`), a API retorna um erro 404 com esta mensagem.
- **Causa Raiz:** O modo de teste do N8N requer que o workflow seja "ativado" manualmente antes de cada chamada. O webhook de teste só fica disponível por uma única execução após clicar em "Execute Workflow".
- **Solução:**
  1.  Abra o workflow no editor do N8N.
  2.  Clique no botão **"Execute Workflow"** (geralmente no canto inferior ou superior direito).
  3.  Imediatamente após clicar, execute a sua chamada de API para o endpoint `/webhook-test/...`.

### Erro 3: Workflow executa código antigo mesmo após salvar

- **Sintoma:** Você corrige um bug no editor, salva (o status muda para "Saved"), mas as execuções em produção continuam falhando com o erro antigo.
- **Causa Raiz:** O N8N utiliza um sistema de **versionamento**. As alterações salvas ficam em um estado de "Draft" (rascunho) e não são aplicadas ao workflow ativo em produção até que sejam publicadas.
- **Solução:** Após salvar suas alterações, clique sempre no botão **"Publish"** no canto superior direito da tela. Isso irá promover a versão de rascunho para a versão de produção.

### Erro 4: Expressão `{{ ... }}` não é interpretada no Body de um HTTP Request

- **Sintoma:** Você envia um corpo JSON para um nó HTTP Request contendo uma expressão como `"prompt": "{{ $(\'Webhook\').item.json.body.mensagem }}"` e o N8N envia a string literal em vez de substituir pelo valor da variável.
- **Causa Raiz:** Quando o modo "Specify Body" está como "Using JSON", o N8N trata o conteúdo como um JSON literal, sem interpretar as expressões internas.
- **Solução:**
  1.  No nó HTTP Request, mude a opção "Specify Body" para **"Using Fields Below"**.
  2.  Adicione cada campo do seu JSON como um item separado na lista.
  3.  Para o campo que precisa da variável (ex: `prompt`), mude o modo do campo para **"Expression"** e insira a sua expressão `{{ ... }}` lá.

### Erro 5: `The connection was aborted, perhaps the server is offline` (Timeout do Ollama)

- **Sintoma:** O workflow fica em execução por vários minutos no nó que chama o Ollama e depois falha com um erro de conexão abortada.
- **Causa Raiz:** O modelo de linguagem (ex: `phi3`) está demorando mais para processar a requisição do que o timeout padrão do nó HTTP Request (geralmente 60 segundos).
- **Solução (em ordem de prioridade):**
  1.  **Otimizar a Requisição:** Adicione o parâmetro `num_predict: 100` (ou um valor baixo) ao corpo da requisição para o Ollama. Isso limita o tamanho da resposta e acelera drasticamente a geração.
  2.  **Aumentar o Timeout:** No nó HTTP Request, vá em **Options** e aumente o valor do campo **Timeout** para `300000` (5 minutos) ou mais.
  3.  **Usar GPU:** Se o seu host tiver uma GPU NVIDIA, reinicie o container do Ollama com o parâmetro `--gpus all` para acelerar o processamento. Veja o script `OTIMIZAR_OLLAMA.ps1`.

---

## 3. Perguntas Frequentes (FAQ)

**P1: Qual a diferença entre `/webhook/` e `/webhook-test/`?**
- **R:** `/webhook/` é o endpoint de **produção**. Ele só funciona se o workflow estiver **ativo e publicado**. `/webhook-test/` é para **debug**. Ele só funciona por uma execução após clicar em "Execute Workflow" no editor.

**P2: Como o N8N se comunica com o Ollama se ambos estão em containers Docker?**
- **R:** Usando a URL especial `http://host.docker.internal:11434`. `host.docker.internal` é um DNS que o Docker Desktop resolve para o IP interno do computador host, permitindo que o container N8N acesse a porta 11434 exposta pelo container Ollama no host.

**P3: Por que meu workflow está inativo ("Inactive") mesmo depois de eu ter salvado?**
- **R:** Salvar ("Save") apenas cria uma versão de rascunho. Você precisa clicar no toggle **"Inactive"** para mudá-lo para **"Active"** e depois clicar em **"Publish"** para que a versão ativa entre em produção.

**P4: Preciso de uma API Key para usar o Ollama local?**
- **R:** Não. A instalação padrão do Ollama não requer chave de API. O campo pode ser deixado em branco na configuração de credenciais do N8N.
