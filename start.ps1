# ============================================================================
# Fraud Detection Demo - Local Startup Script
# ============================================================================
# This script starts all 3 components for the fraud detection demo:
# 1. MCP Server (Python FastMCP service) - port 8000
# 2. Fraud Detection Workflow Backend (Python FastAPI) - port 8001
# 3. Fraud Detection UI (Vite React app) - port 5173
#
# Prerequisites:
# - Azure CLI logged in: az login
# - uv package manager installed
# - Node.js/npm installed
# ============================================================================

param(
    [switch]$SkipBrowser
)

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fraud Detection Demo - Local Setup   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Azure CLI login
Write-Host "Checking Azure CLI login status..." -ForegroundColor Yellow
$azAccount = az account show 2>$null | ConvertFrom-Json
if (-not $azAccount) {
    Write-Host "Not logged into Azure CLI. Please run 'az login' first." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host "Logged in as: $($azAccount.user.name)" -ForegroundColor Green
Write-Host ""

# Start MCP Server (Python FastMCP service)
Write-Host "[1/3] Starting MCP Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
`$host.UI.RawUI.WindowTitle = 'MCP Server (Port 8000)'
Write-Host 'MCP Server - Port 8000' -ForegroundColor Cyan
Write-Host '========================' -ForegroundColor Cyan
cd '$PSScriptRoot\mcp'
uv run python mcp_service.py
"@

Start-Sleep -Seconds 5

# Start Fraud Detection Workflow Backend (Python)
Write-Host "[2/3] Starting Fraud Detection Backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
`$host.UI.RawUI.WindowTitle = 'Fraud Detection Backend (Port 8001)'
Write-Host 'Fraud Detection Backend - Port 8001' -ForegroundColor Cyan
Write-Host '=====================================' -ForegroundColor Cyan
cd '$PSScriptRoot\agentic_ai\workflow\fraud_detection'
uv run python backend.py
"@

Start-Sleep -Seconds 3

# Start Fraud Detection UI (Vite React app)
Write-Host "[3/3] Starting Fraud Detection UI..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
`$host.UI.RawUI.WindowTitle = 'Fraud Detection UI (Port 5173)'
Write-Host 'Fraud Detection UI - Port 5173' -ForegroundColor Cyan
Write-Host '===============================' -ForegroundColor Cyan
cd '$PSScriptRoot\agentic_ai\workflow\fraud_detection\ui'
npm run dev
"@

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  All services started!                " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
Write-Host "  - MCP Server:      http://localhost:8000" -ForegroundColor White
Write-Host "  - Backend API:     http://localhost:8001" -ForegroundColor White
Write-Host "  - Frontend UI:     http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "To stop all services, close the terminal windows." -ForegroundColor Yellow
Write-Host ""

# Open browser
if (-not $SkipBrowser) {
    Write-Host "Opening browser in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Start-Process "http://localhost:5173"
}

