---
name: resume-analyze
description: This skill should be used when the user wants a coach's read on whether to apply to a job and how to improve their odds, an ATS-style keyword screen of their resume against a role, or a hiring manager's gut reaction to it — phrases like "should I apply to this job", "analyze my resume against this JD", "what are my chances", "rate my fit", "will I pass the ATS", "what keywords am I missing", "ATS match score", "what does a recruiter see first", "first impression of my resume", "7-second test", or when they paste a job description and ask for a go/no-go. Runs three passes: an ATS keyword screen (match score 0–100% plus the missing keywords that would filter the resume out), a 7-second hiring-manager scan (first thing noticed, first impression, move-forward yes/no), and a job-search-coach read (apply decision, interview probability, top changes). Read-only — it advises, it does not edit the resume.
version: 0.1.0
allowed-tools: [Bash, Read, mcp__latex-server__read_latex_file]
---

# resume-analyze

Given a job description and the user's resume, run three passes:

1. **ATS screen** — act as the applicant-tracking system filtering resumes for the target
   role. Produce a 0–100% match score and the list of missing keywords that would get the
   resume filtered out before a human ever sees it.
2. **7-second scan** — act as a hiring manager at a company in the target industry who has
   7 seconds to scan the resume. Report the first thing noticed, the first impression, and
   a move-forward yes/no with exactly why.
3. **Coach read** — act as a job search coach: a candid go/no-go, an interview-probability
   estimate, and the highest-leverage changes to make before submitting.

Run them in this order — it mirrors the real funnel: the machine gate (ATS), then the
human glance (7-second scan), then considered judgment (coach). Each stage only matters if
the resume survives the one before it.

## Preconditions
- A master `.tex` exists. Resolve it from persistent memory; if none is recorded, look
  for a `.tex` in the working directory (or ask the user which file to analyze). If
  there's no resume, run **resume-init** / **resume-import** first.
- The user provides a JD (pasted text, a file, or text they paste from a URL). If no JD
  is provided, ask for one — the analysis is meaningless without it.
- Identify the **target role** — the JD's title, or a role the user names. The ATS screen
  filters against that role.
- Identify the **industry/company type** — from the JD or company, or ask. The 7-second
  scan reacts as a hiring manager in that context (what reads as impressive differs by
  industry).

## Approach
1. Read the master and the JD.
2. Extract the JD's hard requirements (must-haves, years of experience, credentials,
   location/work-authorization), its preferred/nice-to-haves, and the seniority and
   domain it targets.
3. Pull the JD's **keywords** — hard skills, tools, certifications, titles, and the exact
   terms it repeats (note the literal phrasing an ATS matches on, e.g. "CI/CD",
   "TypeScript", "project management"). These drive the ATS screen.
4. Map everything honestly against the resume. Separate **clear matches**,
   **partial/transferable matches**, and **genuine gaps**. Don't credit the user for
   experience they don't have.

## Output — Part 1: ATS screen
Act as the ATS filtering resumes for the target role.
1. **Match score, 0–100%.** Weight hard requirements and frequently-repeated keywords
   most. State the one-line basis for the number.
2. **Missing keywords** — list *every* JD keyword absent from the resume that could cause
   an automated filter-out before a human reads it. For each, mark whether the user
   **has the experience but omitted the term** (a safe, high-priority fix) versus a
   **genuine gap** (can't be keyword-stuffed honestly).
3. Flag ATS-hostile formatting if present (e.g. skills buried in images/tables, keywords
   only in a header, non-standard section names) — these sink the score regardless of content.

## Output — Part 2: 7-second scan
Act as a hiring manager for the target role at a company in the target industry, with only
7 seconds to scan the resume. Stay in that snap-judgment headspace — react to what the eye
lands on, don't analyze line by line (that's Part 3).
1. **First thing you notice** — the single element the eye lands on first (a title, a brand
   name, the layout, a gap, a wall of text). Honest, not generous.
2. **First impression** — the gut read those 7 seconds produce, in a sentence or two.
3. **Would you move me forward? Yes or no, and exactly why** — the one or two concrete
   things that drove the call. If "no," name what cost the resume the glance.

## Output — Part 3: coach read — answer these three, in order
1. **Should I apply? Yes or no, with a reason.** Be direct. A "yes" with caveats is fine;
   a soft "maybe" is not — commit to a call and explain the one or two factors that
   drove it. Lean toward "yes" when the gaps are learnable or the role is a stretch in
   the user's favor; lean "no" only when hard requirements are clearly unmet.
2. **Estimated interview probability.** Give a rough band (e.g. Low ~10–25%, Moderate
   ~30–50%, Strong ~55–75%) with a one-line rationale. Frame it as an estimate, not a
   promise, and base it on requirement overlap, seniority fit, and how competitive the
   profile reads — not wishful thinking.
3. **Top 3 changes to make before submitting.** Concrete and specific to this resume and
   this JD — e.g. "lead with the payments project, the JD is 60% fintech," "quantify the
   migration bullet," "add the Kubernetes keyword you have but omitted." Rank by impact.
   If a change implies fabricating experience, don't suggest it.

## Handoff
- If the user wants to act on the changes, hand off to **resume-tailor** (emphasis and
  rephrasing) — that skill makes edits; this one does not.

## Guardrails
- Read-only. This skill analyzes and advises; it never edits the master. Editing is
  **resume-tailor**'s job.
- Be honest, not flattering. An inflated probability or a reflexive "yes, apply!" wastes
  the user's time. Surface real gaps plainly.
- Never recommend fabricating skills, titles, dates, or metrics to close a gap.
- For missing keywords, only suggest adding terms the user genuinely has experience with —
  surfacing the keyword is to recover credit they earned but omitted, never to keyword-stuff
  the ATS with skills they don't have.
