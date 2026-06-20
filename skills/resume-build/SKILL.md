---
name: resume-build
description: This skill should be used when the user wants to compile their resume to PDF — phrases like "build my resume", "compile the resume", "make a pdf", "render the resume", or "generate the pdf". Compiles the LaTeX master to a PDF using the bundled LaTeX MCP server.
version: 0.2.0
allowed-tools: [Bash, Read, mcp__latex-server__validate_latex, mcp__latex-server__compile_latex, mcp__latex-server__list_latex_files]
---

# resume-build

Compile the master resume to a PDF.

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded,
  look for a `.tex` in the working directory (or ask the user which file to build).
  If there's truly no resume, tell them to run **resume-init** or **resume-import**
  first.
- A LaTeX distribution is on PATH (MiKTeX / MacTeX / TeX Live). If `compile_latex`
  reports the engine is missing, point the user at the README troubleshooting.

## Steps
1. `validate_latex` on the master. If it fails, surface the issues and stop — don't
   attempt to compile a file with structural errors.
2. `compile_latex` on the master (default engine `pdflatex`; use `xelatex` or
   `lualatex` only if the master needs custom fonts / fontspec).
3. The server writes the PDF next to the source. Move the PDF and aux files
   (`.aux .log .out`) into a `build/` folder alongside the master (create it if it
   doesn't exist) so the working directory stays clean.
4. Report the path to the PDF. If compilation failed, show the relevant lines from the
   log and propose a fix.

## Notes
- Build output lives in `build/` and is disposable/regenerable.
- Don't add `build/` to the user's `.gitignore` — they may not be in a git repo;
  leave that decision to them.
- Re-run this skill after any edit to the master or after **resume-tailor**.
