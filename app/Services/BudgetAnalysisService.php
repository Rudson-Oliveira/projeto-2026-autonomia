<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class BudgetAnalysisService
{
    protected $ollamaEndpoint;

    public function __construct()
    {
        $this->ollamaEndpoint = env("OLLAMA_ENDPOINT", "http://ollama:11434");
    }

    /**
     * Analisa uma conversa para extrair o perfil comportamental e vulnerabilidades.
     *
     * @param array $conversationData
     * @return array
     */
    public function analyzeBehavioralProfile(array $conversationData): array
    {
        try {
            $prompt = $this->buildOllamaPrompt($conversationData);

            $response = Http::timeout(60)->post("{$this->ollamaEndpoint}/api/generate", [
                "model" => "llama2", // Ou o modelo configurado no docker-compose.env
                "prompt" => $prompt,
                "stream" => false,
                "temperature" => 0.7,
            ]);

            if ($response->failed()) {
                Log::error("Ollama API error: " . $response->body());
                return $this->getDefaultAnalysis();
            }

            $ollamaResponse = json_decode($response->body(), true);
            $analysis = $this->parseOllamaResponse($ollamaResponse["response"] ?? "");

            return $analysis;
        } catch (\Exception $e) {
            Log::error("Erro ao analisar perfil comportamental com Ollama: " . $e->getMessage());
            return $this->getDefaultAnalysis();
        }
    }

    /**
     * Constrói o prompt para o Ollama.
     *
     * @param array $data
     * @return string
     */
    protected function buildOllamaPrompt(array $data): string
    {
        $clientName = $data["clientName"] ?? "";
        $messages = collect($data["messages"] ?? [])->map(function ($m) {
            return "- {$m["timestamp"]}: {$m["text"]}";
        })->implode("\n");
        $familyMembers = collect($data["familyMembers"] ?? [])->map(function ($m) {
            return "- {$m["name"]} ({$m["relationship"]}): {$m["involvement"]}";
        })->implode("\n");
        $previousComplaints = collect($data["previousComplaints"] ?? [])->implode("\n");
        $assistanceHistory = collect($data["assistanceHistory"] ?? [])->map(function ($h) {
            return "- {$h["date"]}: {$h["service"]} ({$h["feedback"]})";
        })->implode("\n");

        return "
Você é um especialista em análise comportamental e vulnerabilidade em cuidados de saúde domiciliar.\n\nAnalise os seguintes dados do cliente e forneça uma avaliação estruturada:\n\nCLIENTE: {$clientName}\n\nMENSAGENS RECENTES:\n{$messages}\n\nMEMBROS DA FAMÍLIA:\n{$familyMembers}\n\nHISTÓRICO DE RECLAMAÇÕES:\n" . ($previousComplaints ?: "Nenhuma reclamação registrada") . "\n\nHISTÓRICO DE ASSISTÊNCIA:\n{$assistanceHistory}\n\nPor favor, forneça uma análise estruturada em JSON com os seguintes campos:\n\n{\n  \"anxietyLevel\": \"Baixo|Médio|Alto\",\n  \"anxietyScore\": 0-100,\n  \"familyEngagement\": \"Baixo|Médio|Alto\",\n  \"engagementScore\": 0-100,\n  \"expectations\": \"descrição das expectativas\",\n  \"vulnerabilities\": [\"vulnerabilidade1\", \"vulnerabilidade2\", ...],\n  \"vulnerabilityRiskScore\": 0-100,\n  \"behavioralProfile\": \"ansioso|colaborativo|independente|desconfiado\",\n  \"recommendations\": [\"recomendação1\", \"recomendação2\", ...],\n  \"pricingAdjustment\": \"Nenhum|Aumento de 5-10%|Aumento de 10-20%|Redução de 5%\",\n  \"summary\": \"resumo executivo da análise\"\n}\n\nSeja preciso e baseie-se nos dados fornecidos.
        ";
    }

    /**
     * Parseia a resposta do Ollama para extrair o JSON.
     *
     * @param string $response
     * @return array
     */
    protected function parseOllamaResponse(string $response): array
    {
        preg_match("/\{[^}]*\}/s", $response, $matches);
        if (isset($matches[0])) {
            return json_decode($matches[0], true);
        }
        return $this->getDefaultAnalysis();
    }

    /**
     * Retorna uma análise padrão em caso de falha.
     *
     * @return array
     */
    protected function getDefaultAnalysis(): array
    {
        return [
            "anxietyLevel" => "Médio",
            "anxietyScore" => 50,
            "familyEngagement" => "Médio",
            "engagementScore" => 50,
            "expectations" => "Análise não disponível",
            "vulnerabilities" => [],
            "vulnerabilityRiskScore" => 50,
            "behavioralProfile" => "colaborativo",
            "recommendations" => ["Agendar conversa com a família"],
            "pricingAdjustment" => "Nenhum",
            "summary" => "Análise padrão - Ollama não disponível"
        ];
    }

    /**
     * Calcula o score de vulnerabilidade combinado.
     *
     * @param array $analysis
     * @param array $logisticsData
     * @param array $marginData
     * @return array
     */
    public function calculateVulnerabilityScore(array $analysis, array $logisticsData, array $marginData): array
    {
        $weights = [
            "behavioral" => 0.35,
            "logistics" => 0.30,
            "financial" => 0.35
        ];

        $behavioralScore = $analysis["vulnerabilityRiskScore"] ?? 50;
        $logisticsScore = $this->calculateLogisticsScore($logisticsData);
        $financialScore = $this->calculateFinancialScore($marginData);

        $totalScore =
            ($behavioralScore * $weights["behavioral"]) +
            ($logisticsScore * $weights["logistics"]) +
            ($financialScore * $weights["financial"]);

        return [
            "totalScore" => round($totalScore),
            "behavioralScore" => $behavioralScore,
            "logisticsScore" => $logisticsScore,
            "financialScore" => $financialScore,
            "riskLevel" => $this->getRiskLevel($totalScore)
        ];
    }

    /**
     * Calcula o score de logística.
     *
     * @param array $logisticsData
     * @return float
     */
    protected function calculateLogisticsScore(array $logisticsData): float
    {
        $distanceToClient = $logisticsData["distanceToClient"] ?? 10;
        $availableProfessionals = $logisticsData["availableProfessionals"] ?? 5;
        $nearbyPharmacies = $logisticsData["nearbyPharmacies"] ?? 3;
        $equipmentDistributors = $logisticsData["equipmentDistributors"] ?? 2;

        $distanceScore = min(($distanceToClient / 50) * 100, 100);
        $supportScore = max(
            100 - (($availableProfessionals + $nearbyPharmacies + $equipmentDistributors) * 10),
            0
        );

        return ($distanceScore + $supportScore) / 2;
    }

    /**
     * Calcula o score financeiro.
     *
     * @param array $marginData
     * @return float
     */
    public function calculateFinancialScore(array $marginData): float
    {
        $marginPercentage = $marginData["marginPercentage"] ?? 20;
        $targetMargin = $marginData["targetMargin"] ?? 20;

        $marginDeviation = abs($marginPercentage - $targetMargin);
        $marginScore = min(($marginDeviation / 20) * 100, 100);

        if ($marginPercentage < 15) {
            return 90;
        }

        if ($marginPercentage < 20) {
            return 70;
        }

        return $marginScore;
    }

    /**
     * Determina o nível de risco.
     *
     * @param float $score
     * @return string
     */
    protected function getRiskLevel(float $score): string
    {
        if ($score >= 70) return 'CRÍTICO';
        if ($score >= 50) return 'ALTO';
        if ($score >= 30) return 'MÉDIO';
        return 'BAIXO';
    }

    /**
     * Gera recomendações de precificação baseadas na análise.
     *
     * @param array $analysis
     * @param float $currentPrice
     * @param float $costPrice
     * @param array $marginData
     * @return array
     */
    public function generatePricingRecommendations(array $analysis, float $currentPrice, float $costPrice, array $marginData): array
    {
        $recommendations = [];
        $vulnerabilityRiskScore = $analysis["vulnerabilityRiskScore"] ?? 0;
        $anxietyScore = $analysis["anxietyScore"] ?? 0;
        $familyEngagement = $analysis["familyEngagement"] ?? "";

        if ($vulnerabilityRiskScore > 70) {
            $recommendations[] = [
                "type" => "BEHAVIORAL_ADJUSTMENT",
                "adjustment" => "+10%",
                "reason" => "Alta vulnerabilidade comportamental requer acompanhamento intensivo",
                "newPrice" => $currentPrice * 1.10
            ];
        }

        if ($familyEngagement === "Alto" && $anxietyScore > 60) {
            $recommendations[] = [
                "type" => "FAMILY_ENGAGEMENT",
                "adjustment" => "+5%",
                "reason" => "Família altamente engajada mas com alta ansiedade - requer mais comunicação",
                "newPrice" => $currentPrice * 1.05
            ];
        }

        $currentMargin = (($currentPrice - $costPrice) / $currentPrice) * 100;
        if ($currentMargin < ($marginData["targetMargin"] ?? 20)) {
            $recommendations[] = [
                "type" => "MARGIN_ALERT",
                "adjustment" => "REVISAR",
                "reason" => "Margem atual (" . round($currentMargin, 1) . "%) abaixo do alvo de " . ($marginData["targetMargin"] ?? 20) . "%",
                "suggestedPrice" => $costPrice / (1 - (($marginData["targetMargin"] ?? 20) / 100)) // Preço para atingir a margem alvo
            ];
        }

        return $recommendations;
    }

    /**
     * Enriquecer dados de orçamento com análises.
     *
     * @param array $budgetData
     * @return array
     */
    public function enrichBudgetData(array $budgetData): array
    {
        try {
            $conversationAnalysis = $this->analyzeBehavioralProfile([
                "clientName" => $budgetData["clientName"] ?? "",
                "phoneNumber" => $budgetData["phoneNumber"] ?? "",
                "messages" => $budgetData["messages"] ?? [],
                "familyMembers" => $budgetData["familyMembers"] ?? [],
                "previousComplaints" => $budgetData["previousComplaints"] ?? [],
                "assistanceHistory" => $budgetData["assistanceHistory"] ?? []
            ]);

            $vulnerabilityScore = $this->calculateVulnerabilityScore(
                $conversationAnalysis,
                $budgetData["logistics"] ?? [],
                $budgetData["margin"] ?? []
            );

            $pricingRecommendations = $this->generatePricingRecommendations(
                $conversationAnalysis,
                $budgetData["totalPrice"] ?? 0,
                $budgetData["costPrice"] ?? 0,
                $budgetData["margin"] ?? []
            );

            return array_merge($budgetData, [
                "behavioralAnalysis" => $conversationAnalysis,
                "vulnerabilityScore" => $vulnerabilityScore,
                "pricingRecommendations" => $pricingRecommendations,
                "enrichedAt" => now()->toISOString(),
            ]);
        } catch (\Exception $e) {
            Log::error("Erro ao enriquecer dados de orçamento: " . $e->getMessage());
            return $budgetData; // Retorna os dados originais em caso de erro
        }
    }
}
