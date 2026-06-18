---
name: resume-init
description: This skill should be used when the user wants to set up Resume Buddy for the first time, asks to "start a resume", "scaffold my resume", "set up resume buddy", "create the data folder", or is a brand-new user with no resume yet. Creates the data/ working layout and seeds a starter LaTeX resume.
version: 0.1.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__validate_latex]
---

# resume-init

Scaffold a working directory for Resume Buddy in the user's current project.

## When to use
- First-time setup, or the user has no `data/resume.tex` yet.
- The user wants a blank resume to start from (no existing resume to import).
  If they DO have an existing resume to bring in, use **resume-import** instead.

## Layout this skill creates
```
data/                 # gitignored — personal content
  inbox/              # drop zone for existing resumes (.tex / .md / .pdf)
  resume.tex          # MASTER — the editable LaTeX resume (source of truth)
  build/              # compiled PDF + LaTeX aux/log files (disposable)
```

## Steps
1. Confirm there is no `data/resume.tex` already. If one exists, stop and tell the
   user — do not overwrite a master. Suggest editing it or running resume-import.
2. Create `data/inbox/` and `data/build/` (add a `.gitkeep` to each).
3. Ensure `data/` is gitignored in the working directory. If a `.gitignore`
   exists and lacks a `data/` entry, append one; if there's no `.gitignore` and
   the directory is a git repo, create one with `data/`. This keeps personal
   content out of version control.
4. Seed the master from the bundled starter template:
   copy `${CLAUDE_PLUGIN_ROOT}/templates/resume.tex` to `data/resume.tex`.
5. Validate it with `validate_latex` on `data/resume.tex`.
6. Tell the user: edit `data/resume.tex` directly, or drop an existing resume into
   `data/inbox/` and ask to import it. To produce a PDF, use **resume-build**.

## Notes
- The master is always `data/resume.tex`. Everything else is input or output.
- Keep personal content under `data/` so it stays gitignored.
