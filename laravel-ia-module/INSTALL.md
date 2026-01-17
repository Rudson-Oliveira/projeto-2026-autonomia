# Instalação do Módulo de IA para Orçamentos

## Visão Geral

Este módulo adiciona funcionalidades de IA ao sistema de orçamentos do Hospitalar Saúde, incluindo:
- Análise de complexidade do paciente (NEAD, ABEMID, PPS)
- Sugestão automática de itens
- Cálculo de orçamentos com IA
- Previsão de aprovação
- Otimização de preços
- Chat com assistente

## Arquivos do Módulo

| Arquivo | Destino no Laravel |
|---------|-------------------|
| `IAOrcamentoController.php` | `app/Http/Controllers/IA/` |
| `IAOrcamentoService.php` | `app/Services/IA/` |
| `IAServiceProvider.php` | `app/Providers/` |
| `ia_routes.php` | Adicionar ao `routes/api.php` |
| `config_ia.php` | `config/ia.php` |

## Instalação Passo a Passo

### 1. Criar Diretórios

```bash
mkdir -p app/Http/Controllers/IA
mkdir -p app/Services/IA
```

### 2. Copiar Arquivos

```bash
# Controller
cp IAOrcamentoController.php app/Http/Controllers/IA/

# Service
cp IAOrcamentoService.php app/Services/IA/

# Provider
cp IAServiceProvider.php app/Providers/

# Config
cp config_ia.php config/ia.php
```

### 3. Registrar Service Provider

Adicionar ao `config/app.php`:

```php
'providers' => [
    // ...
    App\Providers\IAServiceProvider::class,
],
```

### 4. Adicionar Rotas

Adicionar ao final do `routes/api.php`:

```php
// Incluir rotas de IA
require __DIR__ . '/ia_routes.php';
```

Ou copiar o conteúdo de `ia_routes.php` diretamente para `routes/api.php`.

### 5. Configurar Variáveis de Ambiente

Adicionar ao `.env`:

```env
# Ollama
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2
OLLAMA_TIMEOUT=30

# Hub Central
HUB_CENTRAL_URL=http://localhost:5002
HUB_CENTRAL_TIMEOUT=15

# COMET Bridge
COMET_BRIDGE_URL=http://localhost:5000
COMET_BRIDGE_NGROK_URL=https://manus-comet-hospital.ngrok-free.dev
COMET_BRIDGE_TIMEOUT=30

# Vision AI
VISION_AI_URL=https://visionai-khprjuve.manus.space
VISION_AI_ENABLED=true

# Budget Engine
BUDGET_DEFAULT_MARGIN=20
BUDGET_MIN_MARGIN=10
BUDGET_MAX_MARGIN=40

# IA Cache
IA_CACHE_ENABLED=true

# IA Logging
IA_LOGGING_ENABLED=true
IA_LOG_CHANNEL=ia
```

### 6. Limpar Cache

```bash
php artisan config:clear
php artisan route:clear
php artisan cache:clear
```

### 7. Testar Instalação

```bash
# Verificar rotas
php artisan route:list | grep ia

# Testar health check
curl http://localhost:8000/api/ia/health
```

## Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/ia/health` | Health check público |
| GET | `/api/ia/orcamento/health` | Health check autenticado |
| POST | `/api/ia/orcamento/analyze-complexity` | Analisar complexidade |
| POST | `/api/ia/orcamento/suggest-items` | Sugerir itens |
| POST | `/api/ia/orcamento/calculate` | Calcular orçamento |
| POST | `/api/ia/orcamento/predict-approval` | Prever aprovação |
| POST | `/api/ia/orcamento/optimize-prices` | Otimizar preços |
| POST | `/api/ia/orcamento/chat` | Chat com assistente |
| POST | `/api/ia/orcamento/analyze-retifications` | Analisar retificações |

## Exemplos de Uso

### Analisar Complexidade

```bash
curl -X POST http://localhost:8000/api/ia/orcamento/analyze-complexity \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "paciente_id": 123,
    "diagnosticos": [{"codigo": "J18.9", "descricao": "Pneumonia"}],
    "procedimentos": [{"codigo": "99213", "descricao": "Visita médica"}],
    "medicamentos": [{"nome": "Amoxicilina", "controlado": false}],
    "equipamentos": [{"tipo": "oximetro"}]
  }'
```

### Calcular Orçamento

```bash
curl -X POST http://localhost:8000/api/ia/orcamento/calculate \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "paciente_id": 123,
    "operadora_id": 1,
    "tipo_atendimento": "home_care_basic",
    "data_inicial": "2026-01-20",
    "data_final": "2026-02-19",
    "usar_sugestoes": true
  }'
```

### Chat com Assistente

```bash
curl -X POST http://localhost:8000/api/ia/orcamento/chat \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Qual o valor médio de um orçamento de home care básico para 30 dias?",
    "paciente_id": 123
  }'
```

## Troubleshooting

### Ollama não responde

1. Verificar se Ollama está rodando: `curl http://localhost:11434/api/tags`
2. Verificar modelo instalado: `ollama list`
3. Instalar modelo se necessário: `ollama pull llama3.2`

### Erro de autenticação

1. Verificar token JWT válido
2. Verificar middleware de autenticação
3. Verificar configuração do Passport/Sanctum

### Cache não funciona

1. Verificar driver de cache no `.env`
2. Limpar cache: `php artisan cache:clear`
3. Verificar permissões da pasta `storage/framework/cache`

## Suporte

Para suporte, entre em contato com a equipe de desenvolvimento ou consulte a documentação no GitHub:
https://github.com/Rudson-Oliveira/projeto-2026-autonomia
