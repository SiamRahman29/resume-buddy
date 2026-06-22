---
name: resume-critique
description: This skill should be used when the user wants their resume judged on its own merits — no job description involved — against resume best practices, by a senior recruiter's eye. Phrases like "critique my resume", "review my resume", "rate my resume", "how good is my resume", "score my resume", "what's wrong with my resume", "is my resume any good", "roast my resume", "grade my resume", or "give me feedback on my resume". Runs three read-only passes: a principles scorecard (each dimension scored 0–10 against the saved resume principles, with an overall grade), a senior recruiter's verdict (what the resume sells, strongest/weakest element, shortlist yes/no), and a prioritized list of the highest-leverage fixes. Read-only — it advises, it does not edit. For a JD-based go/no-go and ATS screen, use resume-analyze instead.
version: 0.1.0
allowed-tools: [Bash, Read, mcp__latex-server__read_latex_file]
---

# resume-critique

**Read `${CLAUDE_PLUGIN_ROOT}/references/resume-principles.md` first** — it is the
standard this skill judges against. Section 1 (ATOP / quantification) and section 2
(action-verb bank) drive the impact and language scores, section 3 (Do's & Don'ts) is the
hygiene checklist, section 4 (formatting) and section 5 (section structure) drive the
structure/formatting scores, section 6 (ATS-friendliness) flags parser-hostile choices,
and section 8 (industry notes) calibrates the recruiter's read to the candidate's field.

This is the JD-free companion to **resume-analyze**. There is no job description: judge the
resume on its own merits, the way a senior recruiter forms an opinion before any specific
role is on the table. Where resume-analyze asks "does this resume fit *this* job," this
skill asks "is this a strong resume, *period*."

Act as a senior expert recruiter who has read tens of thousands of resumes. Be candid and
specific — flattery wastes the user's time. Run three passes:

1. **Principles scorecard** — grade the resume dimension by dimension against the saved
   principles, each 0–10, then an overall score and letter grade.
2. **Recruiter's verdict** — the snap-judgment read: what role and level this resume sells,
   its strongest and weakest element, and a shortlist yes/no.
3. **Top fixes** — the highest-leverage changes, ranked, concrete to this resume.

Run them in this order: the scorecard establishes the objective state, the verdict is the
human reaction to it, and the fixes are what to do about both.

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded, look
  for a `.tex` in the working directory (or ask the user which file to critique). If
  there's no resume, run **resume-init** / **resume-import** first. Read the resume —
  do not ask the user to paste it.
- **No JD is needed or used.** If the user pastes a job description, point them to
  **resume-analyze** instead — that skill scores fit against a posting; this one doesn't.
- **Target role/field is inferred, not required.** Read the resume's own titles, summary,
  and skills to infer the role and level it's aiming at, and use that to calibrate the
  read (section 8 — what reads as strong differs by industry). If the user names a role or
  field, use it. If it's genuinely ambiguous, say so and critique against the most likely
  reading rather than stalling.

## Approach
1. Read the master end to end. Get the structure, then the content.
2. Hold every section against the principles. Note concrete evidence for each dimension —
   actual bullets, headings, and numbers (or their absence) — so each score is defensible,
   not a vibe. Quote the resume when it sharpens the point.
3. Be honest about what's missing as well as what's there: no quantification, an Objective
   instead of a Summary, a wall of responsibilities, inconsistent dates, two pages for a
   new grad. Absence is a finding.

## Output — Part 1: principles scorecard
Score each dimension **0–10**, with a one-line justification grounded in the resume and the
single highest-leverage fix for that dimension. Then give an **overall score (0–100) and a
letter grade (A–F)** — weight impact, language, and structure most; they decide whether the
resume works.

1. **Impact & quantification** (§1) — Do bullets follow ATOP (action + task + outcome), or
   stop at responsibilities? Are wins quantified (%, $, scale, time)? Count how many bullets
   carry a real number.
2. **Language & action verbs** (§2, §3) — Strong, varied openers? Any banned phrasing
   ("Responsible for," "Duties included," "Helped with," "I/me/my")? Consistent tense?
3. **Structure & sections** (§5) — Are the right sections present and ordered well
   (header → education/experience → skills)? Reverse-chronological? A targeted Summary
   rather than an Objective?
4. **Formatting & consistency** (§4) — Consistent dates, headings, bullets, punctuation,
   fonts? Sane margins and type sizes? This is where sloppiness silently costs interviews.
5. **Conciseness & length** (§4) — Right length for the candidate (one page for most; the
   §8 exceptions aside)? Tight, or padded with filler and low-signal lines?
6. **ATS-friendliness** (§6) — Anything that breaks parsers: tables, text boxes, multi-
   column layouts, images, keywords stranded in a header, non-standard section names?
7. **Hygiene / Do's & Don'ts** (§3) — The fast checklist: no Objective, no "References
   available upon request," no personal info/photo, GPA only if ≥3.0, no insider jargon a
   general reader can't parse.

## Output — Part 2: recruiter's verdict
Stay in a senior recruiter's headspace — the read they form in the first pass, before any
specific role is in play.
1. **What this resume sells** — the role and level it positions the candidate for, in one
   or two sentences. If that's clear and credible, say so; if the resume is muddled about
   who the candidate is, that itself is the finding.
2. **Strongest element** — the one thing that most makes you want to keep reading.
3. **Weakest element** — the one thing that most undercuts the resume; name what it costs.
4. **Would you shortlist this candidate? Yes or no, and exactly why** — for the role the
   resume implies, would it survive your stack? Commit to a call; "it depends" is not an
   answer. If "no," name the one or two things that sank it.

## Output — Part 3: top fixes — ranked
The highest-leverage changes, in priority order, concrete to *this* resume — e.g.
"quantify the migration bullet: it says 'improved performance' with no number," "replace
the Objective with a targeted Summary," "the two Acme roles have inconsistent date
formats," "cut to one page — the 2019 internship bullets are low-signal." Rank by impact:
what would most move this resume from its current grade toward an A. Tie each back to the
dimension it lifts.

## Handoff
- This skill is read-only — it does not edit. To act on the fixes:
  - **resume-tailor** — rewrite bullets, fix emphasis and ordering, edit the master.
  - **resume-summarize** — write or fix the top-of-resume summary.
  - **resume-build** — compile to PDF after edits.
- For a job-specific go/no-go, ATS keyword screen, and interview-probability read, use
  **resume-analyze** with a JD.

## Guardrails
- **Read-only.** This skill critiques and advises; it never edits the master. Editing is
  **resume-tailor**'s / **resume-summarize**'s job — don't edit unprompted.
- **Honest, not flattering.** An inflated grade or a soft "looks great!" wastes the user's
  time. Surface real weaknesses plainly, and back every score with evidence from the resume.
- **Judge against the principles, not a JD.** This skill has no posting to match; don't
  invent requirements or ask for one. If the user wants fit against a specific job, that's
  **resume-analyze**.
- **Never recommend fabricating** skills, titles, dates, or metrics. When a bullet lacks a
  number, tell the user which metric to find and how to compute it (per §1) — never invent one.
