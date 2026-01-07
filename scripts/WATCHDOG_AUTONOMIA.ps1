# 🚀 WATCHDOG DE AUTONOMIA (MANUS AI)
# Este script monitora a saúde dos containers n8n e Ollama e os reinicia automaticamente em caso de falha.

$LogFile = "C:\projeto-2026-autonomia\logs\watchdog.log"

function Write-Log {
    Param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Level] $Message"
    Add-Content -Path $LogFile -Value $LogEntry
    Write-Host $LogEntry
}

function Check-Service {
    Param (
        [string]$ServiceName,
        [string]$Port,
        [string]$ContainerName
    )
    Write-Log "Verificando serviço: $ServiceName na porta $Port..."
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$Port" -TimeoutSec 5 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Log "[$ServiceName] OK. Status Code: $($response.StatusCode)"
            return $true
        } else {
            Write-Log "[$ServiceName] Alerta: Status Code: $($response.StatusCode)" -Level "WARN"
            return $false
        }
    } catch {
        Write-Log "[$ServiceName] ERRO: $($_.Exception.Message)" -Level "ERROR"
        Write-Log "[$ServiceName] Tentando reiniciar o container '$ContainerName'..." -Level "INFO"
        try {
            docker restart $ContainerName
            Start-Sleep -Seconds 30 # Dar tempo para o serviço subir
            $response = Invoke-WebRequest -Uri "http://localhost:$Port" -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Log "[$ServiceName] Container '$ContainerName' reiniciado com sucesso e respondendo." -Level "INFO"
                return $true
            } else {
                Write-Log "[$ServiceName] Container '$ContainerName' reiniciado, mas ainda não respondendo." -Level "ERROR"
                return $false
            }
        } catch {
            Write-Log "[$ServiceName] Falha ao reiniciar o container '$ContainerName': $($_.Exception.Message)" -Level "CRITICAL"
            return $false
        }
    }
}

# Criar diretório de logs se não existir
if (-not (Test-Path (Split-Path $LogFile -Parent))) {
    mkdir (Split-Path $LogFile -Parent)
}

Write-Log "=== INICIANDO WATCHDOG DE AUTONOMIA ==="

# Loop de monitoramento
while ($true) {
    Write-Log "--- Ciclo de monitoramento iniciado ---"
    $n8nHealthy = Check-Service -ServiceName "n8n" -Port "5678" -ContainerName "n8n"
    $ollamaHealthy = Check-Service -ServiceName "Ollama" -Port "11434" -ContainerName "ollama-hospitalar"

    if ($n8nHealthy -and $ollamaHealthy) {
        Write-Log "Todos os serviços estão saudáveis. Próxima verificação em 5 minutos."
    } else {
        Write-Log "Pelo menos um serviço está com problemas. Ações de recuperação foram tentadas." -Level "CRITICAL"
    }

    Start-Sleep -Minutes 5
}
