# Fraud Detection Demo - Start All Components
# Run from: agentic_ai/workflow/fraud_detection

$rootDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$fraudDir = $PSScriptRoot

Write-Host "Starting Fraud Detection Demo..." -ForegroundColor Cyan

# Start MCP Server
Write-Host "Starting MCP Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$rootDir\mcp'; uv run python mcp_service.py"

# Wait for MCP to initialize
Start-Sleep -Seconds 3

# Start Backend
Write-Host "Starting Backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$fraudDir'; & '.\.venv\Scripts\Activate.ps1'; python backend.py"

# Wait for Backend to initialize
Start-Sleep -Seconds 3

# Start UI
Write-Host "Starting UI..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$fraudDir\ui'; npm run dev"

Write-Host ""
Write-Host "All components starting!" -ForegroundColor Green
Write-Host "  MCP Server:  http://localhost:8000" -ForegroundColor White
Write-Host "  Backend:     http://localhost:8080" -ForegroundColor White
Write-Host "  UI:          http://localhost:5173" -ForegroundColor White
