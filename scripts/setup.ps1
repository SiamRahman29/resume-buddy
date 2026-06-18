# One-time setup for resume-buddy (Windows PowerShell)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Set-Location $Root

# The MCP LaTeX server is vendored under vendor/mcp-latex-server (no submodule).
# This script just pre-warms its Python deps and checks for LaTeX. `uv run` also
# installs deps automatically on first launch, so this step is optional.

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Error "uv is not installed. Install from https://docs.astral.sh/uv/getting-started/installation/"
}

Write-Host "Installing MCP LaTeX server dependencies..."
Set-Location "$Root\vendor\mcp-latex-server"
uv sync

Set-Location $Root

if (-not (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
    Write-Warning "pdflatex not found on PATH. Install MiKTeX (https://miktex.org/download) to compile PDFs."
} else {
    Write-Host "LaTeX: $(pdflatex --version | Select-Object -First 1)"
}

Write-Host ""
Write-Host "Setup complete. Start Claude Code from the repo root:"
Write-Host "  cd $Root"
Write-Host "  claude"
