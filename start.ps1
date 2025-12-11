Write-Host "Starting Fraud Detection System..." -ForegroundColor Cyan

# Start MCP Server
Write-Host "Starting MCP Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\mcp-server'; npm start"

Start-Sleep -Seconds 3

# Start Fraud Detection Workflow
Write-Host "Starting Fraud Detection Workflow..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\fraud-detection-workflow'; npm start"

Start-Sleep -Seconds 2

# Start Fraud Detection UI
Write-Host "Starting Fraud Detection UI..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\fraud-detection-ui'; npm run dev"

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host "- MCP Server: Running on configured port"
Write-Host "- Fraud Detection Workflow: Running"
Write-Host "- Fraud Detection UI: http://localhost:5173 (or next available port)"
