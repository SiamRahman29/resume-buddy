---
name: resume-init
description: This skill should be used when the user wants to set up Resume Buddy for the first time, asks to "start a resume", "scaffold my resume", "set up resume buddy", or is a brand-new user with no resume yet. Seeds a starter LaTeX resume in the working directory and records it as the master.
version: 0.2.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__validate_latex]
---

# resume-init

Start a resume from scratch for a user who has nothing to import yet.

## When to use
- Brand-new user with no existing resume — they want a blank slate to build on.
- If the user already HAS a resume (a `.tex` in the working directory, or a
  `.md`/`.pdf` to bring in), use **resume-import** instead — there is nothing to
  scaffold.

## Steps
1. Check whether a master already exists: look in persistent memory for a recorded
   master, then for a `.tex` in the working directory. If one exists, stop and tell
   the user — do not overwrite it. Point them at resume-import (to merge) or at
   editing it directly.
2. Pick the master's filename in the working directory (default `resume.tex`; honor a
   name the user prefers).
3. Seed it from the bundled starter: copy
   `${CLAUDE_PLUGIN_ROOT}/templates/resume.tex` to that path.
4. `validate_latex` on the new file.
5. Record the master's path to persistent memory (a `project` memory) so the other
   skills resolve the same file.
6. Tell the user: edit the master directly, then run **resume-build** for a PDF.

## Notes
- No `data/` layout and no folders to create up front — the resume just lives in the
  working directory. Build artifacts get their own `build/` folder at build time.
- Don't touch the user's `.gitignore`; they may not be in a git repo, and tracking is
  their call.
