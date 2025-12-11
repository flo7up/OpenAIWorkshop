Write-Host "Starting Fraud Detection System..." -ForegroundColor Cyan

# Start MCP Server (Python FastMCP service)
Write-Host "Starting MCP Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\mcp'; uv run python mcp_service.py"

Start-Sleep -Seconds 5

# Start Fraud Detection Workflow Backend (Python)
Write-Host "Starting Fraud Detection Workflow Backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\agentic_ai\workflow\fraud_detection'; uv run python backend.py"

Start-Sleep -Seconds 3

# Start Fraud Detection UI (Vite React app)
Write-Host "Starting Fraud Detection UI..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\agentic_ai\workflow\fraud_detection\ui'; npm run dev"

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host "- MCP Server: http://localhost:8000"
Write-Host "- Fraud Detection Workflow Backend: Running"
Write-Host "- Fraud Detection UI: http://localhost:5173 (or next available port)"
