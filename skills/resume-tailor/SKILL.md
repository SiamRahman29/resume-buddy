---
name: resume-tailor
description: This skill should be used when the user wants to tailor their resume to a specific job — phrases like "tailor my resume to this job", "match this job description", "customize my resume for this role", or when they paste a job posting / JD. Adapts the LaTeX master to emphasize the most relevant experience.
version: 0.2.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__read_latex_file, mcp__latex-server__edit_latex_file, mcp__latex-server__validate_latex, mcp__latex-server__compile_latex]
---

# resume-tailor

Tailor the resume to a specific job description (JD).

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded, look
  for a `.tex` in the working directory (or ask the user). If there's no resume, run
  **resume-init** / **resume-import** first.
- The user provides a JD (pasted text, a file, or a URL they paste the text from).

## Approach
1. Read the master and the JD.
2. Extract the JD's key signals: required skills, responsibilities, seniority, domain,
   and the language/keywords it repeats.
3. Map them against the resume. Identify:
   - bullets to **reorder/emphasize** (most relevant first),
   - phrasing to **align** with the JD's vocabulary (honestly — never invent
     experience the user doesn't have),
   - content to **trim** if the resume runs long for the role.
4. Propose the specific changes to the user before applying. Be explicit about what
   you're rewording and why.

## Output options — ask the user which they want
- **Edit the master in place** — simplest, one resume.
- **Create a tailored variant** — copy to `resume-<company-or-role>.tex` in the
  working directory and edit that, leaving the master untouched. Prefer this when
  they're applying to multiple roles. If the user will keep iterating on a variant,
  note it in persistent memory alongside the master.

## Finishing
1. Apply edits with `edit_latex_file`, then `validate_latex`.
2. Offer to compile (hand off to **resume-build**, or `compile_latex` directly).
3. Summarize the tailoring decisions so the user can sanity-check accuracy.

## Guardrails
- Never fabricate skills, titles, dates, or metrics. Tailoring = emphasis and honest
  rephrasing, not invention.
