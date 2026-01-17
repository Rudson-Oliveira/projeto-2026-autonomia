<?php

namespace App\Providers;

use App\Services\IA\IAOrcamentoService;
use Illuminate\Support\ServiceProvider;

/**
 * Service Provider para serviços de IA
 * 
 * Registra os serviços de IA no container do Laravel
 * 
 * @package App\Providers
 * @author Manus AI
 * @version 1.0.0
 */
class IAServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        // Registrar IAOrcamentoService como singleton
        $this->app->singleton(IAOrcamentoService::class, function ($app) {
            return new IAOrcamentoService();
        });
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        // Publicar configurações se necessário
        if ($this->app->runningInConsole()) {
            $this->publishes([
                __DIR__ . '/../config/ia.php' => config_path('ia.php'),
            ], 'ia-config');
        }
    }
}
