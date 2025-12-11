param()

# Helper: start a new PowerShell window and run a command
function Start-NewWindow {
    param(
        [string]$Title,
        [string]$WorkingDirectory,
        [string]$Command
    )

    Write-Host "Starting: $Title"
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "Set-Location '$WorkingDirectory'; $Command"
    ) -WindowStyle Normal
}

# Resolve repo root as the folder containing this script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# --- Start MCP server ---
Start-NewWindow `
    -Title "MCP Server" `
    -WorkingDirectory "$ScriptDir\mcp" `
    -Command ". .\.venv\Scripts\Activate.ps1; uv run python mcp_service.py"

# --- Start backend ---
Start-NewWindow `
    -Title "Fraud Detection Backend" `
    -WorkingDirectory "$ScriptDir\agentic_ai\workflow\fraud_detection" `
    -Command ". .\.venv\Scripts\Activate.ps1; .\start_backend.bat"

# --- Start frontend ---
Start-NewWindow `
    -Title "Fraud Detection UI" `
    -WorkingDirectory "$ScriptDir\agentic_ai\workflow\fraud_detection\ui" `
    -Command "npm run dev"

Write-Host "All services started (each in its own window)." -ForegroundColor Green
Write-Host "Close this window if you like; other windows will keep running."