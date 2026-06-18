---
name: resume-import
description: This skill should be used when the user wants to bring an existing resume into Resume Buddy — phrases like "import my resume", "I dropped my resume in", "use my markdown/pdf resume", "convert my resume to latex", or when they've added a file to data/inbox/. Handles both first import and re-importing an updated file into the existing LaTeX master.
version: 0.1.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__read_latex_file, mcp__latex-server__edit_latex_file, mcp__latex-server__create_latex_file, mcp__latex-server__validate_latex]
---

# resume-import

Bring an existing resume into the project. The end state is always a valid LaTeX
master at `data/resume.tex`.

## Inputs
Look in `data/inbox/` (and anywhere the user points you) for:
- a `.tex` file  → **primary path**
- a `.md` or `.pdf` file → **fallback path** (fill the starter template)

## Decide: first import vs re-import
- **No `data/resume.tex` yet → first import.**
- **`data/resume.tex` already exists → re-import (a merge, not an overwrite).**
  The LaTeX master is the source of truth. A newly dropped file is treated as an
  incoming patch: diff its content against the master, propose the specific
  changes (added bullets, new role, updated dates), get confirmation, then apply
  them with `edit_latex_file`. **Never blindly overwrite the master** — that would
  wipe the user's LaTeX tweaks.

## First import — primary path (.tex)
1. Copy/move the user's `.tex` to `data/resume.tex`.
2. `validate_latex` on it. If it references missing packages or has errors,
   tell the user; offer to adapt it toward the starter template's package set.
3. Done — `data/resume.tex` is now the master. Suggest **resume-build** for a PDF.

## First import — fallback path (.md / .pdf)
1. Read the source content (Read for .md; for .pdf, read what you can — these are
   often messy exports, so extract meaning, not formatting).
2. Start from the bundled starter: `${CLAUDE_PLUGIN_ROOT}/templates/resume.tex`.
3. **Fill the template, do not mechanically convert.** Map the real content
   (roles, dated bullets, education, projects, skills) into the template's macros
   (`\entry`, `points`, sections). Preserve quantified achievements verbatim.
4. Write the result to `data/resume.tex`, then `validate_latex`.
5. Show the user what you produced and ask them to review before building.

## Output
- `data/resume.tex` exists and validates.
- Summarize what you imported and flag anything you couldn't map cleanly.
