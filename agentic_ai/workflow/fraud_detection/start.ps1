# Fraud Detection Demo - Start All Components
# Run from: agentic_ai/workflow/fraud_detection

$rootDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$fraudDir = $PSScriptRoot

Write-Host "Starting Fraud Detection Demo..." -ForegroundColor Cyan
Write-Host ""

# Start MCP Server
Write-Host "[1/3] Starting MCP Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$rootDir\mcp'; uv run python mcp_service.py"

# Wait for MCP to initialize - needs more time to load
Write-Host "      Waiting for MCP Server to be ready..." -ForegroundColor Gray
Start-Sleep -Seconds 8

# Check if MCP is responding
$mcpReady = $false
for ($i = 0; $i -lt 10; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8000/mcp" -Method GET -TimeoutSec 2 -ErrorAction SilentlyContinue
        $mcpReady = $true
        break
    } catch {
        Write-Host "      MCP not ready yet, retrying... ($($i+1)/10)" -ForegroundColor Gray
        Start-Sleep -Seconds 2
    }
}

if (-not $mcpReady) {
    Write-Host "      Warning: Could not verify MCP is running. Continuing anyway..." -ForegroundColor DarkYellow
}

# Start Backend
Write-Host "[2/3] Starting Backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$fraudDir'; & '.\.venv\Scripts\Activate.ps1'; python backend.py"

# Wait for Backend to initialize
Write-Host "      Waiting for Backend to be ready..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# Start UI
Write-Host "[3/3] Starting UI..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$fraudDir\ui'; npm run dev"

Write-Host ""
Write-Host "All components started!" -ForegroundColor Green
Write-Host ""
Write-Host "  MCP Server:  http://localhost:8000/mcp" -ForegroundColor Cyan
Write-Host "  Backend:     http://localhost:8080" -ForegroundColor Cyan
Write-Host "  UI:          http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "Open http://localhost:5173 in your browser" -ForegroundColor White
