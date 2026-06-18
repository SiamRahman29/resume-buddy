---
name: resume-build
description: This skill should be used when the user wants to compile their resume to PDF — phrases like "build my resume", "compile the resume", "make a pdf", "render the resume", or "generate the pdf". Compiles the LaTeX master to a PDF using the bundled LaTeX MCP server.
version: 0.1.0
allowed-tools: [Bash, Read, mcp__latex-server__validate_latex, mcp__latex-server__compile_latex, mcp__latex-server__list_latex_files]
---

# resume-build

Compile the master resume to a PDF.

## Preconditions
- `data/resume.tex` exists (the master). If not, tell the user to run
  **resume-init** or **resume-import** first.
- A LaTeX distribution is on PATH (MiKTeX / MacTeX / TeX Live). If `compile_latex`
  reports the engine is missing, point the user at the README troubleshooting.

## Steps
1. `validate_latex` on `data/resume.tex`. If it fails, surface the issues and stop
   — don't attempt to compile a file with structural errors.
2. `compile_latex` on `data/resume.tex` (default engine `pdflatex`; use `xelatex`
   or `lualatex` only if the master needs custom fonts / fontspec).
3. The server writes the PDF next to the source. Move/keep the PDF and aux files
   (`.aux .log .out`) under `data/build/` so the working tree stays clean.
4. Report the path to the PDF. If compilation failed, show the relevant lines from
   the log and propose a fix.

## Notes
- The master is `data/resume.tex`; build output lives in `data/build/` and is
  disposable/regenerable.
- Re-run this skill after any edit to the master or after **resume-tailor**.
