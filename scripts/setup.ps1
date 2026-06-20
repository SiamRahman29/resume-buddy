# One-time setup for resume-buddy (Windows PowerShell)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

# The MCP LaTeX server is vendored under vendor/mcp-latex-server (no submodule).
# This script installs uv (if needed) and pre-warms the server's Python deps.
# A LaTeX engine (for compiling PDFs) is installed separately — see the README.

# 1. uv — runs the Python MCP server
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "Installing uv..."
    Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
    # The installer drops uv in ~\.local\bin; make it visible to this session.
    $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Error "uv install failed. Install manually: https://docs.astral.sh/uv/getting-started/installation/"
}
Write-Host "uv: $(uv --version)"

# 2. MCP server dependencies (uv run also does this on first launch)
Write-Host "Installing MCP LaTeX server dependencies..."
Set-Location "$Root\vendor\mcp-latex-server"
uv sync
Set-Location $Root

# 3. LaTeX engine — needed only to compile PDFs
if (-not (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
    Write-Warning "No LaTeX engine found (pdflatex). Install TinyTeX (lightweight, no admin) - see the README's 'LaTeX engine' section."
} else {
    Write-Host "LaTeX: $(pdflatex --version | Select-Object -First 1)"
}

Write-Host ""
Write-Host "Setup complete."
