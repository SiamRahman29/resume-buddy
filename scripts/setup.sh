#!/usr/bin/env bash
# One-time setup for resume-buddy (macOS/Linux)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# The MCP LaTeX server is vendored under vendor/mcp-latex-server (no submodule).
# This script installs uv (if needed) and pre-warms the server's Python deps.
# A LaTeX engine (for compiling PDFs) is installed separately — see the README.

# 1. uv — runs the Python MCP server
if ! command -v uv >/dev/null 2>&1; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # The installer drops uv in ~/.local/bin; make it visible to this session.
  export PATH="$HOME/.local/bin:$PATH"
fi
if ! command -v uv >/dev/null 2>&1; then
  echo "error: uv install failed. See https://docs.astral.sh/uv/getting-started/installation/" >&2
  exit 1
fi
echo "uv: $(uv --version)"

# 2. MCP server dependencies (uv run also does this on first launch)
echo "Installing MCP LaTeX server dependencies..."
(cd vendor/mcp-latex-server && uv sync)

# 3. LaTeX engine — needed only to compile PDFs
if ! command -v pdflatex >/dev/null 2>&1; then
  echo "warning: no LaTeX engine found (pdflatex). Install TinyTeX (lightweight, no admin) — see the README's 'LaTeX engine' section." >&2
else
  echo "LaTeX: $(pdflatex --version | head -n 1)"
fi

echo ""
echo "Setup complete."
