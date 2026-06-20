---
name: cover-letter-write
description: This skill should be used when the user wants a cover letter written for a job — phrases like "write me a cover letter", "draft a cover letter for this role", "cover letter for this JD", or when they paste a job posting and ask for a letter. Acts as a cover letter writer: produces a tight three-paragraph letter grounded in the user's current resume and the job description — it does not restate the resume.
version: 0.1.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__read_latex_file]
---

# cover-letter-write

Act as a cover letter writer. Given the user's resume and a job description, write a
three-paragraph cover letter that complements the resume instead of repeating it.

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded, look
  for a `.tex` in the working directory (or ask the user which file to use). If there's
  no resume, run **resume-init** / **resume-import** first. Read the current resume —
  do not ask the user to paste it.
- The user provides a JD (pasted text, a file, or text they paste from a URL). If no JD
  is provided, ask for one — the letter is meaningless without it.

## Approach
1. Read the master and the JD.
2. From the JD, pull what makes *this* company and role specific: its mission, product,
   problems, values, or recent moves — the things a generic letter could not name.
3. From the resume, pick **one** accomplishment that most directly proves the user can do
   this job. Choose for relevance and evidence (a concrete outcome), not seniority.
4. Draft the letter. The goal is to add signal the resume can't carry — motivation, fit,
   and a story with texture — not to summarize bullets.

## Output — a three-paragraph letter
- **Paragraph 1 — Why this company specifically.** Open with genuine, specific interest
  in the company and role. Name something concrete about them; show you understand what
  they do and why it matters to you. No generic flattery ("I'm excited about this
  opportunity at a fast-growing company").
- **Paragraph 2 — One story that proves I can do the job.** Tell a single, vivid story
  from the user's experience: the situation, what they did, and the result. One story,
  told well, with a real outcome — not a list. It should map to the role's core need.
- **Paragraph 3 — A clear, confident closing.** Restate fit in a sentence, express
  interest in talking further, and close with confidence — not desperation, not
  hedging. Direct and warm.

## Hard rules
- **Do not repeat the resume.** Don't restate bullets, the skills list, or a chronology.
  If a sentence would read the same as a resume line, cut it. The letter earns its place
  by saying what the resume can't.
- **Three paragraphs.** Tight and skimmable — aim for under a page. No fluff paragraphs,
  no "to whom it may concern" filler.
- **Ground every claim in the real resume.** Never fabricate roles, skills, dates, or
  metrics. The story in paragraph 2 must come from the user's actual experience.

## Finishing
1. Show the draft to the user and ask whether they want changes in tone, length, or which
   story leads.
2. Offer to save it to the working directory (e.g. `cover-letter-<company-or-role>.md`,
   or `.tex` if they want it in LaTeX). Don't save unprompted.

## Handoff
- If the user instead wants to adapt the resume itself to the role, hand off to
  **resume-tailor**. For a go/no-go read on whether to apply, hand off to
  **resume-analyze**.
