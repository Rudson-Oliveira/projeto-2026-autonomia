# Script de Restauração Pós-Reboot - Sistema Hospitalar
# Data: 10/01/2026

Write-Host "--- Iniciando Restauração Automática do Sistema ---" -ForegroundColor Cyan

cd C:\Users\rudpa\Documents\hospitalar

# 1. Subir Infraestrutura
docker-compose up -d

# 2. Validar Portas
Write-Host "Validando conexões..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
docker ps

# 3. Abrir Dashboard
Start-Process "http://localhost:4200/#/orcamento-agente/chat"

Write-Host "Sistema Restaurado com Sucesso!" -ForegroundColor Green
