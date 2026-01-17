<?php

namespace App\Http\Controllers\IA;

use App\Http\Controllers\Controller;
use App\Services\IA\IAOrcamentoService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

/**
 * Controller de IA para Orçamentos
 * 
 * Este controller gerencia todas as operações de IA relacionadas a orçamentos,
 * incluindo análise de complexidade, sugestões automáticas e previsões.
 * 
 * @package App\Http\Controllers\IA
 * @author Manus AI
 * @version 1.0.0
 */
class IAOrcamentoController extends Controller
{
    private $iaService;

    public function __construct(IAOrcamentoService $iaService)
    {
        $this->iaService = $iaService;
    }

    /**
     * Analisar complexidade do paciente para orçamento
     * 
     * Calcula scores NEAD, ABEMID e PPS baseado nos dados do paciente
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function analyzeComplexity(Request $request)
    {
        try {
            $validated = $request->validate([
                'paciente_id' => 'required|integer',
                'diagnosticos' => 'nullable|array',
                'procedimentos' => 'nullable|array',
                'medicamentos' => 'nullable|array',
                'equipamentos' => 'nullable|array',
            ]);

            $result = $this->iaService->analyzeComplexity($validated);

            Log::info('IA Orçamento - Análise de complexidade realizada', [
                'paciente_id' => $validated['paciente_id'],
                'scores' => $result['scores'] ?? null
            ]);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Análise de complexidade realizada com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro na análise de complexidade', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Gerar sugestões de itens para orçamento
     * 
     * Baseado no histórico do paciente e diagnósticos, sugere itens
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function suggestItems(Request $request)
    {
        try {
            $validated = $request->validate([
                'paciente_id' => 'required|integer',
                'tipo_atendimento' => 'required|string',
                'diagnostico_principal' => 'nullable|string',
                'periodo_dias' => 'nullable|integer|min:1|max:365',
            ]);

            $result = $this->iaService->suggestItems($validated);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Sugestões geradas com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro ao gerar sugestões', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Calcular orçamento automático
     * 
     * Gera um orçamento completo baseado em IA
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function calculate(Request $request)
    {
        try {
            $validated = $request->validate([
                'paciente_id' => 'required|integer',
                'operadora_id' => 'required|integer',
                'tipo_atendimento' => 'required|string',
                'data_inicial' => 'required|date',
                'data_final' => 'required|date|after_or_equal:data_inicial',
                'itens' => 'nullable|array',
                'usar_sugestoes' => 'nullable|boolean',
            ]);

            $result = $this->iaService->calculateBudget($validated);

            Log::info('IA Orçamento - Cálculo realizado', [
                'paciente_id' => $validated['paciente_id'],
                'valor_total' => $result['valor_total'] ?? 0
            ]);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Orçamento calculado com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro no cálculo', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Prever probabilidade de aprovação
     * 
     * Analisa histórico e padrões para prever aprovação
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function predictApproval(Request $request)
    {
        try {
            $validated = $request->validate([
                'orcamento_id' => 'nullable|integer',
                'operadora_id' => 'required|integer',
                'valor_total' => 'required|numeric|min:0',
                'tipo_atendimento' => 'required|string',
                'itens' => 'nullable|array',
            ]);

            $result = $this->iaService->predictApproval($validated);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Previsão realizada com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro na previsão', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Otimizar preços do orçamento
     * 
     * Sugere ajustes de preços para maximizar aprovação
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function optimizePrices(Request $request)
    {
        try {
            $validated = $request->validate([
                'orcamento_id' => 'required|integer',
                'margem_minima' => 'nullable|numeric|min:0|max:100',
                'priorizar_aprovacao' => 'nullable|boolean',
            ]);

            $result = $this->iaService->optimizePrices($validated);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Otimização realizada com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro na otimização', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Chat com assistente de orçamentos
     * 
     * Endpoint para interação via chat com IA
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function chat(Request $request)
    {
        try {
            $validated = $request->validate([
                'message' => 'required|string|max:2000',
                'context' => 'nullable|array',
                'orcamento_id' => 'nullable|integer',
                'paciente_id' => 'nullable|integer',
            ]);

            $result = $this->iaService->chat($validated);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Resposta gerada com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro no chat', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Analisar retificações pendentes
     * 
     * Identifica padrões e sugere correções automáticas
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function analyzeRetifications(Request $request)
    {
        try {
            $validated = $request->validate([
                'periodo_inicio' => 'nullable|date',
                'periodo_fim' => 'nullable|date',
                'operadora_id' => 'nullable|integer',
            ]);

            $result = $this->iaService->analyzeRetifications($validated);

            return response()->json([
                'success' => true,
                'data' => $result,
                'message' => 'Análise de retificações realizada com sucesso'
            ]);

        } catch (\Exception $e) {
            Log::error('IA Orçamento - Erro na análise de retificações', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Health check do serviço de IA
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function health()
    {
        try {
            $status = $this->iaService->healthCheck();

            return response()->json([
                'success' => true,
                'data' => $status,
                'message' => 'Serviço de IA operacional'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Serviço de IA indisponível: ' . $e->getMessage()
            ], 503);
        }
    }
}
