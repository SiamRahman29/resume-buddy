# Resume Buddy

An AI-powered LaTeX resume workshop. Resume Buddy wires an LLM (Claude Code or Cursor) to a local [MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server) so the AI can create, edit, validate, and compile your resume as a real `.tex` file — no copy-pasting into online editors.

The intended workflow is conversational: tell the AI what you want changed ("add my new job at Acme", "tighten the summary to two lines", "tailor this for a senior backend role"), and it handles the LaTeX directly and produces an updated PDF.

---

## What it does

| Capability | How |
|---|---|
| Create a resume from scratch | AI generates a `.tex` file from your background |
| Edit sections conversationally | AI patches the `.tex` directly via `edit_latex_file` |
| Validate LaTeX syntax | `validate_latex` catches errors before compile |
| Compile to PDF | `compile_latex` runs `pdflatex` / `xelatex` / `lualatex` |
| Inspect document structure | `get_latex_structure` outlines sections and commands |
| Browse existing files | `list_latex_files` / `read_latex_file` |

Resume source files and compiled PDFs live in `data/` (gitignored, so your personal details never land in version control).

---

## Prerequisites

| Tool | Purpose | Install |
|---|---|---|
| [Claude Code](https://code.claude.com/) or [Cursor](https://cursor.com/) | AI front-end that talks to the MCP server | See links |
| [uv](https://docs.astral.sh/uv/getting-started/installation/) | Runs the Python MCP server | `pip install uv` or installer |
| A LaTeX distribution | Compiles `.tex` → PDF | See below |

**LaTeX distributions:**

- **Windows** — [MiKTeX](https://miktex.org/download) (installs packages on demand)
- **macOS** — [MacTeX](https://www.tug.org/mactex/)
- **Linux** — `sudo apt install texlive-full` (or your distro's equivalent)

Verify LaTeX is on your `PATH`:

```
pdflatex --version
```

---

## Setup

Clone with submodules, then run the one-time setup script:

```powershell
# Windows
git clone --recurse-submodules <repo-url>
cd resume-buddy
.\scripts\setup.ps1
```

```bash
# macOS / Linux
git clone --recurse-submodules <repo-url>
cd resume-buddy
./scripts/setup.sh
```

The script:
1. Initialises the `vendor/mcp-latex-server` git submodule
2. Runs `uv sync` inside the submodule to install Python dependencies
3. Checks that `pdflatex` is available and warns if not

If you cloned without `--recurse-submodules`, run:

```
git submodule update --init --recursive
```

---

## Running

### Claude Code

```bash
cd resume-buddy
claude
```

On first launch, approve the `latex-server` MCP when prompted. You can check MCP status with `/mcp` inside the session.

### Cursor

Open the `resume-buddy` folder as your workspace. Cursor picks up `.mcp.json` automatically and connects to the `latex-server` on startup. The `CLAUDE.md` file in the repo root provides context to the AI about available tools.

---

## Usage examples

Once your AI session is running, talk to it naturally:

```
Create a software engineer resume for me. I'll give you my background.
```

```
Add a new position: Senior Engineer at Acme Corp, Jan 2024–present.
Focus on distributed systems work.
```

```
Tailor my resume for this job description: [paste JD]
```

```
Compile my resume to PDF.
```

```
The margins feel tight — switch to a two-column layout for the skills section.
```

---

## Project structure

```
resume-buddy/
├── .mcp.json              # MCP server config (latex-server via uv)
├── .claude/
│   └── settings.json      # Enables latex-server for Claude Code
├── CLAUDE.md              # Agent instructions and tool reference
├── scripts/
│   ├── setup.ps1          # Windows setup
│   └── setup.sh           # macOS/Linux setup
├── vendor/
│   └── mcp-latex-server/  # Git submodule — Python MCP server
└── data/                  # Your resume files (gitignored)
    ├── *.tex
    └── *.pdf
```

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| MCP server not listed / not connecting | Run from the repo root; confirm `.mcp.json` exists |
| `uv: command not found` | Install uv and restart your terminal |
| Compile fails with LaTeX errors | Ask the AI to `validate_latex` first; it will show the error |
| `pdflatex` not found | Install MiKTeX / MacTeX / texlive and ensure it's on `PATH` |
| `vendor/mcp-latex-server` is empty | Run `git submodule update --init --recursive` |
| Claude Code rejected the server earlier | Run `claude mcp reset-project-choices` |
