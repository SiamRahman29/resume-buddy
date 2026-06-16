# Resume Buddy

LaTeX resume tooling for Claude Code via the [MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server).

## Prerequisites

- [Claude Code](https://code.claude.com/)
- [uv](https://docs.astral.sh/uv/getting-started/installation/) (Python package manager)
- A LaTeX distribution on `PATH` for PDF compilation:
  - Windows: [MiKTeX](https://miktex.org/download)
  - macOS: [MacTeX](https://www.tug.org/mactex/)
  - Linux: `texlive-full` (or your distro equivalent)

## First-time setup

After cloning:

```powershell
# Windows
.\scripts\setup.ps1
```

```bash
# macOS / Linux
./scripts/setup.sh
```

This initializes the `vendor/mcp-latex-server` submodule and runs `uv sync` to install Python dependencies.

## Using the LaTeX MCP in Claude Code

1. Open a terminal in this repository root.
2. Run `claude`.
3. On first use, approve the `latex-server` MCP when prompted (or check `/mcp`).

The server is configured in `.mcp.json`. LaTeX files are read and written relative to the repo root (`LATEX_SERVER_BASE_PATH=.`).

### Available tools

- `create_latex_file` / `create_from_template` — start new documents
- `edit_latex_file` — modify existing `.tex` files
- `read_latex_file` / `list_latex_files` — browse sources
- `validate_latex` / `get_latex_structure` — check syntax and outline
- `compile_latex` — build PDF (`pdflatex`, `xelatex`, or `lualatex`)

## Troubleshooting

| Issue | Fix |
|-------|-----|
| MCP server not listed | Run from repo root; confirm `.mcp.json` exists |
| `uv` not found | Install uv and restart your terminal |
| Compile fails | Run `pdflatex --version`; install MiKTeX/TeX Live |
| Submodule empty | `git submodule update --init --recursive` |
| Server rejected earlier | `claude mcp reset-project-choices` |
