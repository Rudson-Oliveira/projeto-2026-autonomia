<?php

/**
 * Configurações do módulo de IA
 * 
 * Salvar como config/ia.php no Laravel
 * 
 * @author Manus AI
 * @version 1.0.0
 */

return [

    /*
    |--------------------------------------------------------------------------
    | Ollama Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para conexão com o Ollama local
    |
    */
    'ollama' => [
        'url' => env('OLLAMA_URL', 'http://localhost:11434'),
        'model' => env('OLLAMA_MODEL', 'llama3.2'),
        'timeout' => env('OLLAMA_TIMEOUT', 30),
    ],

    /*
    |--------------------------------------------------------------------------
    | Hub Central Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para conexão com o Hub Central
    |
    */
    'hub_central' => [
        'url' => env('HUB_CENTRAL_URL', 'http://localhost:5002'),
        'timeout' => env('HUB_CENTRAL_TIMEOUT', 15),
    ],

    /*
    |--------------------------------------------------------------------------
    | COMET Bridge Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para conexão com o COMET Bridge
    |
    */
    'comet_bridge' => [
        'url' => env('COMET_BRIDGE_URL', 'http://localhost:5000'),
        'ngrok_url' => env('COMET_BRIDGE_NGROK_URL', 'https://manus-comet-hospital.ngrok-free.dev'),
        'timeout' => env('COMET_BRIDGE_TIMEOUT', 30),
    ],

    /*
    |--------------------------------------------------------------------------
    | Vision AI Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para o VisionAI
    |
    */
    'vision_ai' => [
        'url' => env('VISION_AI_URL', 'https://visionai-khprjuve.manus.space'),
        'enabled' => env('VISION_AI_ENABLED', true),
    ],

    /*
    |--------------------------------------------------------------------------
    | Budget Engine Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para o motor de orçamentos
    |
    */
    'budget_engine' => [
        'default_margin' => env('BUDGET_DEFAULT_MARGIN', 20),
        'min_margin' => env('BUDGET_MIN_MARGIN', 10),
        'max_margin' => env('BUDGET_MAX_MARGIN', 40),
        'cache_ttl' => env('BUDGET_CACHE_TTL', 3600), // 1 hora
    ],

    /*
    |--------------------------------------------------------------------------
    | Complexity Analysis Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para análise de complexidade
    |
    */
    'complexity' => [
        'nead_weight' => 0.35,
        'abemid_weight' => 0.35,
        'pps_weight' => 0.30,
        'thresholds' => [
            'muito_baixa' => 20,
            'baixa' => 40,
            'media' => 60,
            'alta' => 80,
            'muito_alta' => 100,
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Approval Prediction Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações para previsão de aprovação
    |
    */
    'approval_prediction' => [
        'min_history_for_high_confidence' => 10,
        'value_thresholds' => [
            'low' => 10000,
            'medium' => 30000,
            'high' => 50000,
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Cache Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações de cache para IA
    |
    */
    'cache' => [
        'enabled' => env('IA_CACHE_ENABLED', true),
        'prefix' => 'ia_orcamento_',
        'ttl' => [
            'complexity' => 1800, // 30 minutos
            'suggestions' => 3600, // 1 hora
            'predictions' => 900, // 15 minutos
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Logging Configuration
    |--------------------------------------------------------------------------
    |
    | Configurações de log para IA
    |
    */
    'logging' => [
        'enabled' => env('IA_LOGGING_ENABLED', true),
        'channel' => env('IA_LOG_CHANNEL', 'ia'),
        'level' => env('IA_LOG_LEVEL', 'info'),
    ],

];
