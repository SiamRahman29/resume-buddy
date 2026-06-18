#!/usr/bin/env bash
# One-time setup for resume-buddy (macOS/Linux)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# The MCP LaTeX server is vendored under vendor/mcp-latex-server (no submodule).
# This script just pre-warms its Python deps and checks for LaTeX. `uv run` also
# installs deps automatically on first launch, so this step is optional.

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
