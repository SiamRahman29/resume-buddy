---
name: resume-summarize
description: This skill should be used when the user wants to write or rewrite the summary at the top of their resume — phrases like "rewrite my summary", "write my professional summary", "fix my resume summary", "punch up my headline/profile section", or "write a summary for this role". Acts as a top-1% resume writer: produces a sharp 3–4 sentence summary, targeted at a role, that tells a recruiter in a 5-second skim that the user is right for the job. Specific, no generic phrases. Offers to drop it into the master.
version: 0.1.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__read_latex_file, mcp__latex-server__edit_latex_file, mcp__latex-server__validate_latex]
---

# resume-summarize

Act as a top-1% resume writer. Given the user's resume and the role they're targeting,
rewrite the summary section (the 3–4 sentence profile/summary at the top of the resume)
so that a recruiter skimming it for 5 seconds immediately knows the user is the right
person for this role.

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded, look
  for a `.tex` in the working directory (or ask the user which file to use). If there's
  no resume, run **resume-init** / **resume-import** first. Read the current resume —
  do not ask the user to paste it.
- Identify the **target role**. It can be a full JD (pasted text, a file, or text from a
  URL) or just a role title the user names. If the user gives nothing, ask what role
  they're aiming for — a summary with no target is generic by construction.

## Approach
1. Read the master. Find the existing summary section if there is one (it may be called
   Summary, Profile, About, Objective, or be an untitled lead paragraph), so the rewrite
   is a drop-in replacement.
2. Mine the resume for the **specifics** that prove fit: the user's strongest title and
   years, signature skills, and one or two quantified wins (scale, impact, outcomes).
   Everything in the summary must be backed by the resume — never invent.
3. Read the target role for what it actually wants: the seniority, the core problem, the
   must-have skills, and the literal terms it leans on. Aim the summary at those.
4. Write for the 5-second skim. The first sentence should land the user as the right
   level and kind of person for the role before the recruiter reads anything else.

## Output — a 3–4 sentence summary
- **Sentence 1 — the positioning line.** Who the user is in this role's terms: title +
  years + the one domain or strength that matches the role. This is the line that has to
  do the work in 5 seconds.
- **Sentences 2–3 — the proof.** Concrete, resume-backed evidence aimed at the role's
  core need — a quantified outcome, the scale they've operated at, the exact skills the
  role names. Specifics, not adjectives.
- **Optional sentence 4 — the fit/forward line.** What the user is looking to do next, in
  this role's direction — only if it adds signal, not filler.

## Hard rules
- **Specific, not generic.** Ban filler: "results-driven," "proven track record,"
  "team player," "passionate professional," "detail-oriented," "synergy," "go-getter."
  If a sentence could appear on a stranger's resume, rewrite it until it can't.
- **3–4 sentences, no more.** A summary that runs long isn't read. Tight and skimmable.
- **Ground every claim in the real resume.** Never fabricate titles, skills, years, or
  metrics to fit the role. If the resume doesn't support a claim, leave it out.
- **Mirror the role's language where it's honest** — using the role's exact terms for
  skills the user genuinely has helps both the recruiter and the ATS, but never keyword-
  stuff with skills they don't have.

## Finishing
1. Show the rewritten summary to the user. If a previous summary existed, show it
   alongside so they can compare.
2. Offer to drop it into the master — replace the existing summary section, or insert one
   if there wasn't one. Edit the master in place via the latex-server; validate after.
   Don't edit unprompted.

## Handoff
- To adapt the rest of the resume (bullets, emphasis, ordering) to the role, hand off to
  **resume-tailor**. For a go/no-go read on whether to apply, hand off to
  **resume-analyze**. To compile after editing, hand off to **resume-build**.
