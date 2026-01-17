<?php

namespace App\Services\IA;

use App\Models\Paciente\Orcamento\PacienteOrcamento;
use App\Models\Paciente\Orcamento\PacienteOrcamentoItem;
use App\Models\Paciente\Paciente;
use App\Models\Operadora\Operadora;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

/**
 * Service de IA para Orçamentos
 * 
 * Gerencia toda a lógica de negócio relacionada à IA para orçamentos,
 * incluindo integração com Ollama local e análises preditivas.
 * 
 * @package App\Services\IA
 * @author Manus AI
 * @version 1.0.0
 */
class IAOrcamentoService
{
    /**
     * URL do Ollama local
     */
    private $ollamaUrl;

    /**
     * URL do Hub Central
     */
    private $hubCentralUrl;

    /**
     * Modelo padrão do Ollama
     */
    private $defaultModel;

    public function __construct()
    {
        $this->ollamaUrl = env('OLLAMA_URL', 'http://localhost:11434');
        $this->hubCentralUrl = env('HUB_CENTRAL_URL', 'http://localhost:5002');
        $this->defaultModel = env('OLLAMA_MODEL', 'llama3.2');
    }

    /**
     * Analisar complexidade do paciente
     * 
     * Calcula scores NEAD, ABEMID e PPS
     * 
     * @param array $data
     * @return array
     */
    public function analyzeComplexity(array $data): array
    {
        $pacienteId = $data['paciente_id'];
        
        // Buscar dados do paciente
        $paciente = Paciente::with(['internacoes', 'orcamentos.itens'])->find($pacienteId);
        
        if (!$paciente) {
            throw new \Exception('Paciente não encontrado');
        }

        // Calcular scores baseados nos dados
        $neadScore = $this->calculateNeadScore($paciente, $data);
        $abemidScore = $this->calculateAbemidScore($paciente, $data);
        $ppsScore = $this->calculatePpsScore($paciente, $data);

        // Determinar nível de complexidade
        $avgScore = ($neadScore + $abemidScore + $ppsScore) / 3;
        $complexityLevel = $this->getComplexityLevel($avgScore);

        // Gerar recomendações via IA
        $recommendations = $this->generateComplexityRecommendations($paciente, [
            'nead' => $neadScore,
            'abemid' => $abemidScore,
            'pps' => $ppsScore
        ]);

        return [
            'paciente_id' => $pacienteId,
            'scores' => [
                'nead' => $neadScore,
                'abemid' => $abemidScore,
                'pps' => $ppsScore,
                'media' => round($avgScore, 2)
            ],
            'complexity_level' => $complexityLevel,
            'recommendations' => $recommendations,
            'analyzed_at' => Carbon::now()->toIso8601String()
        ];
    }

    /**
     * Calcular score NEAD
     */
    private function calculateNeadScore($paciente, array $data): float
    {
        $score = 0;
        
        // Pontuação baseada em diagnósticos
        $diagnosticos = $data['diagnosticos'] ?? [];
        $score += count($diagnosticos) * 5;
        
        // Pontuação baseada em procedimentos
        $procedimentos = $data['procedimentos'] ?? [];
        $score += count($procedimentos) * 8;
        
        // Pontuação baseada em medicamentos
        $medicamentos = $data['medicamentos'] ?? [];
        $score += count($medicamentos) * 3;
        
        // Pontuação baseada em equipamentos
        $equipamentos = $data['equipamentos'] ?? [];
        $score += count($equipamentos) * 10;
        
        // Histórico de internações
        $internacoes = $paciente->internacoes ?? collect();
        $score += $internacoes->count() * 5;
        
        return min(100, $score);
    }

    /**
     * Calcular score ABEMID
     */
    private function calculateAbemidScore($paciente, array $data): float
    {
        $score = 0;
        
        // Critérios ABEMID simplificados
        $procedimentos = $data['procedimentos'] ?? [];
        
        foreach ($procedimentos as $proc) {
            // Procedimentos de alta complexidade
            if (isset($proc['complexidade']) && $proc['complexidade'] === 'alta') {
                $score += 15;
            } elseif (isset($proc['complexidade']) && $proc['complexidade'] === 'media') {
                $score += 8;
            } else {
                $score += 3;
            }
        }
        
        // Medicamentos especiais
        $medicamentos = $data['medicamentos'] ?? [];
        foreach ($medicamentos as $med) {
            if (isset($med['controlado']) && $med['controlado']) {
                $score += 10;
            } else {
                $score += 2;
            }
        }
        
        return min(100, $score);
    }

    /**
     * Calcular score PPS (Palliative Performance Scale)
     */
    private function calculatePpsScore($paciente, array $data): float
    {
        // Score PPS padrão (pode ser ajustado com dados reais)
        $baseScore = 70;
        
        $equipamentos = $data['equipamentos'] ?? [];
        
        // Equipamentos que indicam menor autonomia
        foreach ($equipamentos as $equip) {
            if (isset($equip['tipo'])) {
                switch (strtolower($equip['tipo'])) {
                    case 'ventilador':
                    case 'respirador':
                        $baseScore -= 20;
                        break;
                    case 'cama_hospitalar':
                        $baseScore -= 10;
                        break;
                    case 'cadeira_rodas':
                        $baseScore -= 15;
                        break;
                }
            }
        }
        
        return max(0, min(100, $baseScore));
    }

    /**
     * Determinar nível de complexidade
     */
    private function getComplexityLevel(float $score): string
    {
        if ($score >= 80) return 'muito_alta';
        if ($score >= 60) return 'alta';
        if ($score >= 40) return 'media';
        if ($score >= 20) return 'baixa';
        return 'muito_baixa';
    }

    /**
     * Gerar recomendações via Ollama
     */
    private function generateComplexityRecommendations($paciente, array $scores): array
    {
        try {
            $prompt = "Baseado nos seguintes scores de complexidade de um paciente de home care:
            - NEAD: {$scores['nead']}/100
            - ABEMID: {$scores['abemid']}/100
            - PPS: {$scores['pps']}/100
            
            Forneça 3 recomendações objetivas para o orçamento deste paciente.
            Responda em formato JSON com array 'recomendacoes'.";

            $response = $this->callOllama($prompt);
            
            if (isset($response['recomendacoes'])) {
                return $response['recomendacoes'];
            }
            
            return [
                'Avaliar necessidade de equipamentos especializados',
                'Considerar frequência de visitas profissionais',
                'Verificar cobertura da operadora para procedimentos complexos'
            ];
            
        } catch (\Exception $e) {
            Log::warning('Falha ao gerar recomendações via Ollama', ['error' => $e->getMessage()]);
            return [
                'Avaliar necessidade de equipamentos especializados',
                'Considerar frequência de visitas profissionais',
                'Verificar cobertura da operadora para procedimentos complexos'
            ];
        }
    }

    /**
     * Sugerir itens para orçamento
     */
    public function suggestItems(array $data): array
    {
        $pacienteId = $data['paciente_id'];
        $tipoAtendimento = $data['tipo_atendimento'];
        $periodoDias = $data['periodo_dias'] ?? 30;

        // Buscar histórico do paciente
        $paciente = Paciente::with(['orcamentos.itens'])->find($pacienteId);
        
        // Buscar template de atendimento
        $template = $this->getAttendanceTemplate($tipoAtendimento);
        
        // Buscar itens frequentes do paciente
        $itensFrequentes = $this->getFrequentItems($paciente);
        
        // Gerar sugestões via IA
        $sugestoes = $this->generateItemSuggestions($template, $itensFrequentes, $periodoDias);

        return [
            'paciente_id' => $pacienteId,
            'tipo_atendimento' => $tipoAtendimento,
            'periodo_dias' => $periodoDias,
            'sugestoes' => $sugestoes,
            'template_base' => $template['nome'] ?? 'padrao',
            'generated_at' => Carbon::now()->toIso8601String()
        ];
    }

    /**
     * Obter template de atendimento
     */
    private function getAttendanceTemplate(string $tipo): array
    {
        $templates = [
            'home_care_basic' => [
                'nome' => 'Home Care Básico',
                'categorias' => ['procedimentos', 'medicamentos', 'materiais'],
                'profissionais' => ['enfermeiro', 'tecnico_enfermagem'],
                'frequencia_visitas' => 'diaria'
            ],
            'home_care_complex' => [
                'nome' => 'Home Care Complexo',
                'categorias' => ['procedimentos', 'medicamentos', 'materiais', 'equipamentos', 'opme'],
                'profissionais' => ['enfermeiro', 'tecnico_enfermagem', 'fisioterapeuta', 'medico'],
                'frequencia_visitas' => 'multiplas_diarias'
            ],
            'palliative_care' => [
                'nome' => 'Cuidados Paliativos',
                'categorias' => ['procedimentos', 'medicamentos', 'materiais', 'equipamentos'],
                'profissionais' => ['enfermeiro', 'tecnico_enfermagem', 'medico', 'psicologo'],
                'frequencia_visitas' => 'diaria'
            ],
            'post_surgical' => [
                'nome' => 'Pós-Cirúrgico',
                'categorias' => ['procedimentos', 'medicamentos', 'materiais', 'curativos'],
                'profissionais' => ['enfermeiro', 'tecnico_enfermagem', 'fisioterapeuta'],
                'frequencia_visitas' => 'diaria'
            ]
        ];

        return $templates[$tipo] ?? $templates['home_care_basic'];
    }

    /**
     * Obter itens frequentes do paciente
     */
    private function getFrequentItems($paciente): array
    {
        if (!$paciente || !$paciente->orcamentos) {
            return [];
        }

        $itens = [];
        foreach ($paciente->orcamentos as $orcamento) {
            foreach ($orcamento->itens as $item) {
                $key = $item->produto_id ?? $item->descricao;
                if (!isset($itens[$key])) {
                    $itens[$key] = [
                        'descricao' => $item->descricao,
                        'tipo' => $item->tipo,
                        'frequencia' => 0
                    ];
                }
                $itens[$key]['frequencia']++;
            }
        }

        // Ordenar por frequência
        uasort($itens, function($a, $b) {
            return $b['frequencia'] - $a['frequencia'];
        });

        return array_slice(array_values($itens), 0, 20);
    }

    /**
     * Gerar sugestões de itens
     */
    private function generateItemSuggestions(array $template, array $itensFrequentes, int $periodoDias): array
    {
        $sugestoes = [];

        // Adicionar itens frequentes
        foreach ($itensFrequentes as $item) {
            $sugestoes[] = [
                'descricao' => $item['descricao'],
                'tipo' => $item['tipo'],
                'quantidade_sugerida' => $periodoDias,
                'fonte' => 'historico_paciente',
                'confianca' => 0.9
            ];
        }

        // Adicionar itens do template
        foreach ($template['categorias'] as $categoria) {
            $sugestoes[] = [
                'descricao' => "Itens de {$categoria}",
                'tipo' => $categoria,
                'quantidade_sugerida' => $periodoDias,
                'fonte' => 'template',
                'confianca' => 0.7
            ];
        }

        return $sugestoes;
    }

    /**
     * Calcular orçamento completo
     */
    public function calculateBudget(array $data): array
    {
        $pacienteId = $data['paciente_id'];
        $operadoraId = $data['operadora_id'];
        $tipoAtendimento = $data['tipo_atendimento'];
        $dataInicial = Carbon::parse($data['data_inicial']);
        $dataFinal = Carbon::parse($data['data_final']);
        $periodoDias = $dataInicial->diffInDays($dataFinal) + 1;

        // Buscar dados necessários
        $paciente = Paciente::find($pacienteId);
        $operadora = Operadora::find($operadoraId);

        if (!$paciente || !$operadora) {
            throw new \Exception('Paciente ou Operadora não encontrados');
        }

        // Usar sugestões se solicitado
        $itens = $data['itens'] ?? [];
        if (($data['usar_sugestoes'] ?? false) && empty($itens)) {
            $sugestoes = $this->suggestItems([
                'paciente_id' => $pacienteId,
                'tipo_atendimento' => $tipoAtendimento,
                'periodo_dias' => $periodoDias
            ]);
            $itens = $sugestoes['sugestoes'];
        }

        // Calcular valores
        $valorTotal = 0;
        $itensCalculados = [];

        foreach ($itens as $item) {
            $valorItem = $this->calculateItemValue($item, $operadora, $periodoDias);
            $valorTotal += $valorItem['valor_total'];
            $itensCalculados[] = $valorItem;
        }

        // Análise de margem
        $margemAnalysis = $this->analyzeMargin($valorTotal, $operadora);

        return [
            'paciente' => [
                'id' => $paciente->id,
                'nome' => $paciente->nome
            ],
            'operadora' => [
                'id' => $operadora->id,
                'nome' => $operadora->nome
            ],
            'periodo' => [
                'inicio' => $dataInicial->format('Y-m-d'),
                'fim' => $dataFinal->format('Y-m-d'),
                'dias' => $periodoDias
            ],
            'itens' => $itensCalculados,
            'valor_total' => round($valorTotal, 2),
            'margem' => $margemAnalysis,
            'calculated_at' => Carbon::now()->toIso8601String()
        ];
    }

    /**
     * Calcular valor de item
     */
    private function calculateItemValue(array $item, $operadora, int $periodoDias): array
    {
        $quantidade = $item['quantidade_sugerida'] ?? $periodoDias;
        $valorUnitario = $item['valor_unitario'] ?? 10.00; // Valor padrão
        $valorTotal = $quantidade * $valorUnitario;

        return [
            'descricao' => $item['descricao'],
            'tipo' => $item['tipo'] ?? 'outros',
            'quantidade' => $quantidade,
            'valor_unitario' => round($valorUnitario, 2),
            'valor_total' => round($valorTotal, 2)
        ];
    }

    /**
     * Analisar margem
     */
    private function analyzeMargin(float $valorTotal, $operadora): array
    {
        $custoEstimado = $valorTotal * 0.7; // Estimativa de 70% de custo
        $margem = $valorTotal - $custoEstimado;
        $margemPercentual = ($margem / $valorTotal) * 100;

        return [
            'custo_estimado' => round($custoEstimado, 2),
            'margem_valor' => round($margem, 2),
            'margem_percentual' => round($margemPercentual, 2),
            'status' => $margemPercentual >= 20 ? 'saudavel' : ($margemPercentual >= 10 ? 'atencao' : 'critico')
        ];
    }

    /**
     * Prever probabilidade de aprovação
     */
    public function predictApproval(array $data): array
    {
        $operadoraId = $data['operadora_id'];
        $valorTotal = $data['valor_total'];
        $tipoAtendimento = $data['tipo_atendimento'];

        // Buscar histórico de aprovações da operadora
        $historico = $this->getApprovalHistory($operadoraId);

        // Calcular probabilidade baseada em histórico
        $probabilidade = $this->calculateApprovalProbability($historico, $valorTotal, $tipoAtendimento);

        // Fatores de risco
        $fatoresRisco = $this->identifyRiskFactors($data, $historico);

        // Sugestões para aumentar aprovação
        $sugestoes = $this->generateApprovalSuggestions($fatoresRisco);

        return [
            'probabilidade_aprovacao' => round($probabilidade, 2),
            'nivel_confianca' => $historico['total_orcamentos'] > 10 ? 'alto' : 'medio',
            'fatores_risco' => $fatoresRisco,
            'sugestoes' => $sugestoes,
            'historico_operadora' => [
                'total_orcamentos' => $historico['total_orcamentos'],
                'taxa_aprovacao' => $historico['taxa_aprovacao']
            ]
        ];
    }

    /**
     * Obter histórico de aprovações
     */
    private function getApprovalHistory(int $operadoraId): array
    {
        $orcamentos = PacienteOrcamento::where('operadora_id', $operadoraId)
            ->whereNotNull('status')
            ->get();

        $total = $orcamentos->count();
        $aprovados = $orcamentos->where('status', 'APROVADO')->count();

        return [
            'total_orcamentos' => $total,
            'aprovados' => $aprovados,
            'taxa_aprovacao' => $total > 0 ? round(($aprovados / $total) * 100, 2) : 50.0
        ];
    }

    /**
     * Calcular probabilidade de aprovação
     */
    private function calculateApprovalProbability(array $historico, float $valorTotal, string $tipoAtendimento): float
    {
        $baseProbability = $historico['taxa_aprovacao'];

        // Ajustar baseado no valor
        if ($valorTotal > 50000) {
            $baseProbability -= 10;
        } elseif ($valorTotal < 10000) {
            $baseProbability += 5;
        }

        // Ajustar baseado no tipo de atendimento
        $tiposComMaiorAprovacao = ['home_care_basic', 'post_surgical'];
        if (in_array($tipoAtendimento, $tiposComMaiorAprovacao)) {
            $baseProbability += 5;
        }

        return max(0, min(100, $baseProbability));
    }

    /**
     * Identificar fatores de risco
     */
    private function identifyRiskFactors(array $data, array $historico): array
    {
        $fatores = [];

        if ($data['valor_total'] > 50000) {
            $fatores[] = [
                'fator' => 'valor_alto',
                'descricao' => 'Valor total acima de R$ 50.000',
                'impacto' => 'alto'
            ];
        }

        if ($historico['taxa_aprovacao'] < 60) {
            $fatores[] = [
                'fator' => 'historico_operadora',
                'descricao' => 'Operadora com baixa taxa de aprovação histórica',
                'impacto' => 'medio'
            ];
        }

        return $fatores;
    }

    /**
     * Gerar sugestões para aprovação
     */
    private function generateApprovalSuggestions(array $fatoresRisco): array
    {
        $sugestoes = [];

        foreach ($fatoresRisco as $fator) {
            switch ($fator['fator']) {
                case 'valor_alto':
                    $sugestoes[] = 'Considere dividir o orçamento em períodos menores';
                    break;
                case 'historico_operadora':
                    $sugestoes[] = 'Inclua documentação detalhada de justificativa médica';
                    break;
            }
        }

        if (empty($sugestoes)) {
            $sugestoes[] = 'Orçamento dentro dos parâmetros normais';
        }

        return $sugestoes;
    }

    /**
     * Otimizar preços do orçamento
     */
    public function optimizePrices(array $data): array
    {
        $orcamentoId = $data['orcamento_id'];
        $margemMinima = $data['margem_minima'] ?? 15;
        $priorizarAprovacao = $data['priorizar_aprovacao'] ?? true;

        $orcamento = PacienteOrcamento::with('itens')->find($orcamentoId);

        if (!$orcamento) {
            throw new \Exception('Orçamento não encontrado');
        }

        $itensOtimizados = [];
        $valorOriginal = 0;
        $valorOtimizado = 0;

        foreach ($orcamento->itens as $item) {
            $valorOriginal += $item->valor_total;
            
            $otimizacao = $this->optimizeItemPrice($item, $margemMinima, $priorizarAprovacao);
            $itensOtimizados[] = $otimizacao;
            $valorOtimizado += $otimizacao['valor_otimizado'];
        }

        return [
            'orcamento_id' => $orcamentoId,
            'valor_original' => round($valorOriginal, 2),
            'valor_otimizado' => round($valorOtimizado, 2),
            'economia' => round($valorOriginal - $valorOtimizado, 2),
            'economia_percentual' => $valorOriginal > 0 ? round((($valorOriginal - $valorOtimizado) / $valorOriginal) * 100, 2) : 0,
            'itens' => $itensOtimizados
        ];
    }

    /**
     * Otimizar preço de item
     */
    private function optimizeItemPrice($item, float $margemMinima, bool $priorizarAprovacao): array
    {
        $valorOriginal = $item->valor_total;
        $valorOtimizado = $valorOriginal;

        if ($priorizarAprovacao) {
            // Reduzir preço para aumentar chance de aprovação
            $valorOtimizado = $valorOriginal * 0.95;
        }

        return [
            'item_id' => $item->id,
            'descricao' => $item->descricao,
            'valor_original' => round($valorOriginal, 2),
            'valor_otimizado' => round($valorOtimizado, 2),
            'ajuste' => round($valorOriginal - $valorOtimizado, 2)
        ];
    }

    /**
     * Chat com assistente
     */
    public function chat(array $data): array
    {
        $message = $data['message'];
        $context = $data['context'] ?? [];

        // Construir contexto para o Ollama
        $systemPrompt = "Você é um assistente especializado em orçamentos de home care hospitalar. 
        Responda de forma objetiva e profissional em português brasileiro.
        Foque em ajudar com cálculos, análises e sugestões para orçamentos.";

        $response = $this->callOllama($message, $systemPrompt);

        return [
            'response' => $response['message'] ?? 'Desculpe, não consegui processar sua mensagem.',
            'context_updated' => $context,
            'timestamp' => Carbon::now()->toIso8601String()
        ];
    }

    /**
     * Analisar retificações
     */
    public function analyzeRetifications(array $data): array
    {
        $periodoInicio = isset($data['periodo_inicio']) ? Carbon::parse($data['periodo_inicio']) : Carbon::now()->subMonths(3);
        $periodoFim = isset($data['periodo_fim']) ? Carbon::parse($data['periodo_fim']) : Carbon::now();

        // Buscar orçamentos com retificações
        $query = PacienteOrcamento::whereBetween('created_at', [$periodoInicio, $periodoFim])
            ->whereNotNull('retificacao_motivo');

        if (isset($data['operadora_id'])) {
            $query->where('operadora_id', $data['operadora_id']);
        }

        $orcamentos = $query->get();

        // Analisar padrões
        $padroes = $this->identifyRetificationPatterns($orcamentos);

        return [
            'periodo' => [
                'inicio' => $periodoInicio->format('Y-m-d'),
                'fim' => $periodoFim->format('Y-m-d')
            ],
            'total_retificacoes' => $orcamentos->count(),
            'padroes_identificados' => $padroes,
            'recomendacoes' => $this->generateRetificationRecommendations($padroes)
        ];
    }

    /**
     * Identificar padrões de retificação
     */
    private function identifyRetificationPatterns($orcamentos): array
    {
        $padroes = [];
        $motivos = [];

        foreach ($orcamentos as $orcamento) {
            $motivo = $orcamento->retificacao_motivo ?? 'nao_especificado';
            if (!isset($motivos[$motivo])) {
                $motivos[$motivo] = 0;
            }
            $motivos[$motivo]++;
        }

        arsort($motivos);

        foreach ($motivos as $motivo => $count) {
            $padroes[] = [
                'motivo' => $motivo,
                'ocorrencias' => $count,
                'percentual' => $orcamentos->count() > 0 ? round(($count / $orcamentos->count()) * 100, 2) : 0
            ];
        }

        return array_slice($padroes, 0, 5);
    }

    /**
     * Gerar recomendações para retificações
     */
    private function generateRetificationRecommendations(array $padroes): array
    {
        $recomendacoes = [];

        foreach ($padroes as $padrao) {
            if ($padrao['percentual'] > 20) {
                $recomendacoes[] = "Atenção especial ao motivo '{$padrao['motivo']}' que representa {$padrao['percentual']}% das retificações";
            }
        }

        if (empty($recomendacoes)) {
            $recomendacoes[] = 'Nenhum padrão crítico identificado no período';
        }

        return $recomendacoes;
    }

    /**
     * Chamar Ollama local
     */
    private function callOllama(string $prompt, string $systemPrompt = ''): array
    {
        try {
            $response = Http::timeout(30)->post("{$this->ollamaUrl}/api/generate", [
                'model' => $this->defaultModel,
                'prompt' => $prompt,
                'system' => $systemPrompt,
                'stream' => false
            ]);

            if ($response->successful()) {
                $data = $response->json();
                return [
                    'message' => $data['response'] ?? '',
                    'success' => true
                ];
            }

            throw new \Exception('Falha na comunicação com Ollama');

        } catch (\Exception $e) {
            Log::warning('Ollama indisponível', ['error' => $e->getMessage()]);
            return [
                'message' => 'Serviço de IA temporariamente indisponível',
                'success' => false
            ];
        }
    }

    /**
     * Health check
     */
    public function healthCheck(): array
    {
        $ollamaStatus = false;
        $hubCentralStatus = false;

        // Verificar Ollama
        try {
            $response = Http::timeout(5)->get("{$this->ollamaUrl}/api/tags");
            $ollamaStatus = $response->successful();
        } catch (\Exception $e) {
            $ollamaStatus = false;
        }

        // Verificar Hub Central
        try {
            $response = Http::timeout(5)->get("{$this->hubCentralUrl}/health");
            $hubCentralStatus = $response->successful();
        } catch (\Exception $e) {
            $hubCentralStatus = false;
        }

        return [
            'service' => 'IA Orcamento Service',
            'version' => '1.0.0',
            'status' => 'operational',
            'dependencies' => [
                'ollama' => $ollamaStatus ? 'online' : 'offline',
                'hub_central' => $hubCentralStatus ? 'online' : 'offline'
            ],
            'checked_at' => Carbon::now()->toIso8601String()
        ];
    }
}
