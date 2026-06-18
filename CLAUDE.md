# Resume Buddy

A Claude Code **plugin** for working on resumes in LaTeX. It bundles the
[MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server) (vendored under
`vendor/mcp-latex-server`) plus skills for importing, building, and tailoring resumes.

## The model

- **Master = `data/resume.tex`.** This is the single source of truth and the file
  the agent edits. Everything else is input or output.
- **`data/inbox/`** is the drop zone for a user's existing resume (`.tex`, `.md`,
  or `.pdf`).
- **`data/build/`** holds compiled PDFs and LaTeX aux/log files (disposable).
- **`data/` is gitignored** — personal content never lands in version control.
- **`templates/resume.tex`** is committed starter scaffolding, used only when a user
  arrives without LaTeX (a `.md`/`.pdf`).

## Workflow rules for the agent

- **Bring-your-own-`.tex` is the primary path.** If the user has a `.tex`, it
  becomes `data/resume.tex` and you edit it directly — no template, no conversion.
- **`.md`/`.pdf` is the fallback path.** Fill `templates/resume.tex` with the user's
  real content (map meaning into the macros — do not mechanically convert).
- **LaTeX is master; re-drops are merges, not overwrites.** If the user later drops
  an updated file while a master exists, treat it as an incoming patch: diff against
  `data/resume.tex`, propose specific changes, confirm, then apply. Never clobber the
  master and wipe manual LaTeX tweaks.
- **Which file is current?** Rely on user instructions and persistent memory, not
  on bookkeeping files. The master is always `data/resume.tex`.

## Skills

- `resume-init` — scaffold `data/` and seed a starter master for a new user.
- `resume-import` — bring an existing resume in (first import or re-import/merge).
- `resume-build` — compile the master to PDF in `data/build/`.
- `resume-tailor` — tailor the master (or a variant) to a job description.

## LaTeX MCP tools (`latex-server`)

- `create_latex_file` / `create_from_template` — start new documents
- `edit_latex_file` — modify existing `.tex` files
- `read_latex_file` / `list_latex_files` — browse sources
- `validate_latex` / `get_latex_structure` — check syntax and outline
- `compile_latex` — build PDF (`pdflatex`, `xelatex`, or `lualatex`)

Files are read/written relative to the user's working directory
(`LATEX_SERVER_BASE_PATH=.`); the server code is located via `${CLAUDE_PLUGIN_ROOT}`.

## Notes

- A LaTeX distribution must be on `PATH` for compilation (MiKTeX / MacTeX / TeX Live).
- `uv` runs the Python server; `uv run` auto-installs dependencies on first launch.
