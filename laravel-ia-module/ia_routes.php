<?php

/**
 * Rotas da API de IA para Orçamentos
 * 
 * Adicionar este conteúdo ao arquivo routes/api.php do Laravel
 * 
 * @author Manus AI
 * @version 1.0.0
 */

use App\Http\Controllers\IA\IAOrcamentoController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Rotas de IA para Orçamentos
|--------------------------------------------------------------------------
|
| Estas rotas fornecem endpoints para integração de IA no módulo de orçamentos.
| Todas as rotas são protegidas por autenticação JWT.
|
*/

Route::prefix('ia')->middleware(['auth:api'])->group(function () {
    
    /*
    |--------------------------------------------------------------------------
    | Orçamentos - IA
    |--------------------------------------------------------------------------
    */
    Route::prefix('orcamento')->group(function () {
        
        // Health check do serviço de IA
        Route::get('/health', [IAOrcamentoController::class, 'health'])
            ->name('ia.orcamento.health');
        
        // Analisar complexidade do paciente
        Route::post('/analyze-complexity', [IAOrcamentoController::class, 'analyzeComplexity'])
            ->name('ia.orcamento.analyze-complexity');
        
        // Sugerir itens para orçamento
        Route::post('/suggest-items', [IAOrcamentoController::class, 'suggestItems'])
            ->name('ia.orcamento.suggest-items');
        
        // Calcular orçamento automático
        Route::post('/calculate', [IAOrcamentoController::class, 'calculate'])
            ->name('ia.orcamento.calculate');
        
        // Prever probabilidade de aprovação
        Route::post('/predict-approval', [IAOrcamentoController::class, 'predictApproval'])
            ->name('ia.orcamento.predict-approval');
        
        // Otimizar preços do orçamento
        Route::post('/optimize-prices', [IAOrcamentoController::class, 'optimizePrices'])
            ->name('ia.orcamento.optimize-prices');
        
        // Chat com assistente de orçamentos
        Route::post('/chat', [IAOrcamentoController::class, 'chat'])
            ->name('ia.orcamento.chat');
        
        // Analisar retificações pendentes
        Route::post('/analyze-retifications', [IAOrcamentoController::class, 'analyzeRetifications'])
            ->name('ia.orcamento.analyze-retifications');
    });
});

/*
|--------------------------------------------------------------------------
| Rotas Públicas de IA (sem autenticação)
|--------------------------------------------------------------------------
*/
Route::prefix('ia')->group(function () {
    
    // Health check público
    Route::get('/health', [IAOrcamentoController::class, 'health'])
        ->name('ia.health.public');
});
