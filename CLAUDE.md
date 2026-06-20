# Resume Buddy

A Claude Code **plugin** for working on resumes in LaTeX. It bundles the
[MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server) (vendored under
`vendor/mcp-latex-server`) plus skills for importing, building, and tailoring resumes.

## The model

- **The master is a `.tex` file you resolve per session**, not a fixed path. It's the
  resume the user already keeps in the working directory, or one they name. There is
  no `data/` scaffolding to create.
- **Persist the master's path to memory** (a `project` memory) so every skill agrees
  on the current file. Resolve it once, record it, reuse it.
- **Builds go in a `build/` folder next to the master** — compiled PDFs and LaTeX
  aux/log files (disposable, regenerable).
- **`templates/resume.tex`** is committed starter scaffolding, seeded only when a user
  arrives with no resume at all.
- **Never touch the user's `.gitignore`.** They may not be in a git repo, and whether
  the resume or build artifacts are tracked is their call.

## Workflow rules for the agent

- **Resolve the master first.** Check memory for a recorded master path. If none, look
  for a `.tex` in the working directory; if exactly one, adopt it; if several or none,
  ask the user (or take a path they name). Record the result to memory.
- **Bring-your-own-`.tex` is the primary path.** If the user has a `.tex`, that file IS
  the master — edit it in place. No template, no conversion, no copying.
- **`.md`/`.pdf` is the fallback path.** Fill `templates/resume.tex` with the user's
  real content (map meaning into the macros — do not mechanically convert), and write
  the result as a `.tex` in the working directory.
- **LaTeX is master; re-drops are merges, not overwrites.** If the user later drops an
  updated file, treat it as an incoming patch: diff against the master, propose
  specific changes, confirm, then apply. Never clobber the master and wipe manual
  LaTeX tweaks.
- **Which file is current?** Persistent memory first, then the working directory — not
  bookkeeping files.

## Skills

- `resume-init` — seed a starter master in the working directory for a user with no
  resume yet, and record it to memory.
- `resume-import` — bring an existing resume in (first import or re-import/merge).
- `resume-build` — compile the master to a PDF in `build/`.
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
