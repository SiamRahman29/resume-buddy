#!/usr/bin/env bash
# One-time setup for resume-buddy (macOS/Linux)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "Initializing git submodules..."
git submodule update --init --recursive

if ! command -v uv >/dev/null 2>&1; then
  echo "error: uv is not installed. See https://docs.astral.sh/uv/getting-started/installation/" >&2
  exit 1
fi

echo "Installing MCP LaTeX server dependencies..."
(cd vendor/mcp-latex-server && uv sync)

if ! command -v pdflatex >/dev/null 2>&1; then
  echo "warning: pdflatex not found. Install a LaTeX distribution to compile PDFs." >&2
else
  echo "LaTeX: $(pdflatex --version | head -n 1)"
fi

echo ""
echo "Setup complete. Start Claude Code from the repo root:"
echo "  cd $ROOT"
echo "  claude"
