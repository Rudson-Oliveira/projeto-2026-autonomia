# GUIA DE GO-LIVE IMEDIATO - SISTEMA HOSPITALAR AUTÔNOMO

**Data:** 10 de Janeiro de 2026
**Versão:** 1.0

Este guia detalha os passos finais para a implementação e ativação completa do sistema HospitaLar, integrando a inteligência artificial (Ollama), o agente multimodelo (Obsidian Agent) e a automação robótica de processos (UiPath).

## 1. Pré-requisitos Essenciais

Certifique-se de que os seguintes itens estão configurados no ambiente local:

*   **Docker Desktop:** Instalado e em execução.
*   **Git:** Instalado e configurado.
*   **PowerShell:** Versão 5.1 ou superior.
*   **Diretório do Projeto:** `C:\Users\rudpa\Documents\hospitalar` (ou o caminho configurado nos scripts PowerShell).
*   **Acesso à Internet:** Para download de modelos Ollama e sincronização com GitHub.

## 2. Execução dos Scripts de Instalação e Integração

Os scripts PowerShell foram projetados para automatizar a maior parte da configuração. Siga estes passos:

1.  **Abra o PowerShell como Administrador.**
2.  **Navegue até o diretório do projeto:**
    ```powershell
    cd C:\Users\rudpa\Documents\hospitalar
    ```
3.  **Execute o comando de Autonomia Total:** Este comando irá baixar as versões mais recentes dos scripts, configurar a infraestrutura Docker (Ollama e PostgreSQL), e copiar os arquivos do backend e frontend para os locais corretos.
    ```powershell
    Remove-Item -Path "IMPLEMENTACAO_TOTAL_HOSPITALLAR.ps1", "INTEGRACAO_FRONTEND_HOSPITALAR.ps1" -Force -ErrorAction SilentlyContinue;
    $ts = Get-Date -Format "yyyyMMddHHmmss";
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Rudson-Oliveira/projeto-2026-autonomia/master/IMPLEMENTACAO_TOTAL_HOSPITALLAR.ps1?t=$ts" -OutFile "IMPLEMENTACAO_TOTAL_HOSPITALLAR.ps1";
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Rudson-Oliveira/projeto-2026-autonomia/master/INTEGRACAO_FRONTEND_HOSPITALAR.ps1?t=$ts" -OutFile "INTEGRACAO_FRONTEND_HOSPITALAR.ps1";
    powershell -ExecutionPolicy Bypass -File .\IMPLEMENTACAO_TOTAL_HOSPITALLAR.ps1;
    powershell -ExecutionPolicy Bypass -File .\INTEGRACAO_FRONTEND_HOSPITALAR.ps1;
    ```

4.  **Verifique o Log:** Observe a saída do PowerShell para garantir que todos os passos foram concluídos com sucesso. Mensagens como `IMPLEMENTACAO CONCLUIDA COM SUCESSO!` e `INTEGRACAO FRONTEND FINALIZADA!` devem aparecer.

## 3. Configuração do Agente Multimodelo (Obsidian Agent)

O Agente Multimodelo é o orquestrador da inteligência. Ele foi atualizado para incluir as regras de negócio do HospitaLar.

1.  **Navegue até o diretório do agente:**
    ```bash
    cd C:\Users\rudpa\Documents\hospitalar\obsidian-agente\agent
    ```
2.  **Instale as dependências Python:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Inicie o Agente:**
    ```bash
    python intelligent_agent.py
    ```
    *   O agente iniciará um servidor Flask, geralmente na porta `5000`.

## 4. Configuração do Backend Laravel

O backend Laravel atua como a ponte entre o frontend, o Agente Multimodelo e a UiPath.

1.  **Ajuste o `.env` do Laravel:** Certifique-se de que as seguintes variáveis de ambiente estão configuradas:
    ```dotenv
    UIPATH_ORCHESTRATOR_URL="https://cloud.uipath.com/hospitalarsaude"
    UIPATH_CLIENT_ID="4579-0379-7019-4236"
    UIPATH_USER_EMAIL="rud.pa@hotmail.com"
    OBSIDIAN_AGENT_URL="http://localhost:5000" # Ou a porta que o agente estiver rodando
    ```
2.  **Execute as Migrações e Seeders (se necessário):**
    ```bash
    php artisan migrate --seed
    ```
3.  **Inicie o Servidor Laravel:**
    ```bash
    php artisan serve
    ```

## 5. Integração do Frontend (Angular/Vue)

Os componentes `dashboard-vulnerability-margin.vue` e `menu-captacao.vue` foram copiados para o seu projeto. Agora é necessário integrá-los à sua aplicação.

1.  **Integre o `menu-captacao.vue`:** Adicione o componente ao seu layout principal ou barra de navegação, garantindo que os links para as novas funcionalidades estejam visíveis.
2.  **Integre o `dashboard-vulnerability-margin.vue`:** Crie uma nova rota na sua aplicação frontend (ex: `/orcamento/vulnerabilidade`) e associe-a a este componente.
3.  **Conecte os Componentes ao Backend:** Implemente as chamadas HTTP (Axios, Fetch, etc.) do frontend para os endpoints do Laravel que acionam o `BudgetAnalysisService` e o `UiPathService`.

## 6. Desenvolvimento dos Robôs UiPath (Sprint 2 - Próximo Passo)

Esta etapa envolve a criação dos robôs no UiPath Studio.

1.  **Crie um novo Projeto no UiPath Studio.**
2.  **Desenvolva os Workflows:**
    *   **Robô de Elegibilidade:** Recebe dados do paciente do Laravel, navega no portal do convênio e retorna o status de elegibilidade.
    *   **Robô de Faturamento:** Recebe os dados da guia do Laravel, navega no portal do convênio e lança o faturamento.
3.  **Publique no UiPath Orchestrator:** Certifique-se de que os robôs estão publicados e configurados para serem acionados via API.

## 7. Testes e Homologação

Realize testes completos para garantir que todo o fluxo funcione:

*   **Teste de Ponta a Ponta:** Desde a entrada de dados (simulando WhatsApp) até a visualização no dashboard e a execução dos robôs UiPath.
*   **Validação de Margens:** Verifique se a regra de 20% está sendo aplicada corretamente.
*   **Análise de Vulnerabilidade:** Confirme se os scores de risco estão sendo gerados e exibidos.

## 8. Suporte e Monitoramento

*   Monitore os logs do Agente Multimodelo e do Laravel para identificar e corrigir quaisquer problemas.
*   Utilize o Dashboard de Vulnerabilidade para acompanhar o desempenho do sistema.

--- 

**Com este guia, você tem o roteiro completo para ativar a Autonomia Total do HospitaLar amanhã cedo. Boa sorte!**
