<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class UiPathService
{
    protected $orchestratorUrl;
    protected $clientId;
    protected $clientSecret;
    protected $tenantName;
    protected $accountName;
    protected $accessToken;

    public function __construct()
    {
        $this->orchestratorUrl = env('UIPATH_ORCHESTRATOR_URL');
        $this->clientId = env('UIPATH_CLIENT_ID');
        $this->clientSecret = env('UIPATH_CLIENT_SECRET');
        $this->tenantName = env('UIPATH_TENANT_NAME');
        $this->accountName = env('UIPATH_ACCOUNT_NAME');
    }

    /**
     * Obtém o token de acesso OAuth2 da UiPath.
     *
     * @return string|null
     */
    protected function getAccessToken(): ?string
    {
        if ($this->accessToken) {
            return $this->accessToken;
        }

        try {
            $response = Http::asForm()->post("{$this->orchestratorUrl}/oauth/token", [
                'grant_type' => 'client_credentials',
                'client_id' => $this->clientId,
                'client_secret' => $this->clientSecret,
                'scope' => 'Orchestrator',
            ]);

            if ($response->successful()) {
                $this->accessToken = $response->json('access_token');
                return $this->accessToken;
            }

            Log::error('UiPath OAuth Token Error: ' . $response->body());
            return null;
        } catch (\Exception $e) {
            Log::error('Erro ao obter token UiPath: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Dispara um processo (Job) na UiPath.
     *
     * @param string $processName O nome do processo a ser disparado (ex: "FaturamentoGuiaConvenio").
     * @param array $inputArguments Argumentos de entrada para o processo (JSON).
     * @return array|null O resultado do disparo do job ou null em caso de falha.
     */
    public function startProcess(string $processName, array $inputArguments = []): ?array
    {
        $token = $this->getAccessToken();
        if (!$token) {
            return null;
        }

        try {
            $response = Http::withToken($token)
                ->post("{$this->orchestratorUrl}/odata/Jobs/UiPath.Server.Configuration.OData.StartJobs", [
                    'startInfo' => [
                        'ReleaseKey' => $processName, // Ou o nome da Release
                        'Strategy' => 'All',
                        'RobotIds' => [], // Opcional: IDs de robôs específicos
                        'InputArguments' => json_encode($inputArguments),
                    ],
                ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('UiPath Start Process Error: ' . $response->body());
            return null;
        } catch (\Exception $e) {
            Log::error('Erro ao disparar processo UiPath: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Consulta o status de um Job na UiPath.
     *
     * @param int $jobId O ID do Job a ser consultado.
     * @return array|null O status do job ou null em caso de falha.
     */
    public function getJobStatus(int $jobId): ?array
    {
        $token = $this->getAccessToken();
        if (!$token) {
            return null;
        }

        try {
            $response = Http::withToken($token)
                ->get("{$this->orchestratorUrl}/odata/Jobs(" . $jobId . ")");

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('UiPath Get Job Status Error: ' . $response->body());
            return null;
        } catch (\Exception $e) {
            Log::error('Erro ao consultar status do Job UiPath: ' . $e->getMessage());
            return null;
        }
    }
}
