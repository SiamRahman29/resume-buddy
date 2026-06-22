---
name: resume-import
description: This skill should be used when the user wants to bring an existing resume into Resume Buddy — phrases like "import my resume", "I dropped my resume in", "use my markdown/pdf resume", "convert my resume to latex". Handles both first import and re-importing an updated file into the existing LaTeX master.
version: 0.5.0
allowed-tools: [Bash, Read, Write, mcp__latex-server__read_latex_file, mcp__latex-server__edit_latex_file, mcp__latex-server__create_latex_file, mcp__latex-server__validate_latex, mcp__latex-server__compile_latex]
---

# resume-import

Bring an existing resume into the project. The end state is always a valid LaTeX
master in the working directory, recorded to memory.

## Iron rule: reproduce the source, don't reinterpret it
The imported `.tex` must be a faithful reproduction of what the user gave you — not
a redesign, not a "better" version. **Never invent, drop, reword, reorder, or
"improve" content.** Every line, date, number, title, and bullet comes from the
source verbatim. Tailoring and rewriting are other skills (**resume-tailor**,
**resume-summarize**); import only mirrors. If something in the source is genuinely
unreadable, flag it — do not fill the gap with a guess.

Once imported, change the master only when the user explicitly asks — then apply those
edits to the LaTeX directly with `edit_latex_file`. The starter template is **only** for
generating a resume from details the user types into the prompt; never impose it on a
resume the user already has.

## Iron rule: reproduce the *typography*, not just the words
Content fidelity is not enough — **the look of every element must match the source
exactly.** Reproducing the text while flattening its styling is a failed import. For
each piece of text, carry over **all four** typographic dimensions:
- **Font / typeface** — serif vs. sans, the actual family if identifiable.
- **Font size** — relative hierarchy at minimum (the name is the largest thing on the
  page; section headings are larger than body; body is uniform). Match LaTeX size
  commands (`\Huge`, `\Large`, `\large`, `\normalsize`, …) to the source's scale.
- **Weight** — bold vs. regular vs. light. **If a word is bold in the source it MUST be
  bold in the `.tex`** (`\textbf{…}`), and if it's regular it must stay regular.
- **Color** — any non-black text (headings, name, rules, links) is reproduced with the
  matching color via `xcolor` (`\textcolor{…}` / `\color{…}`); estimate the hex if it
  isn't pure black.

This applies to every styled element — the header, section headings, job titles, company
names, and dates each carry their own weight, size, and color that must be preserved, not
flattened to plain body text.

## Find the source
Look in the working directory (and anywhere the user points you) for:
- a `.tex` file → **use it in place** (primary path)
- a `.pdf` file → **reproduce it exactly as LaTeX**
- a `.md` file → **reproduce its content and structure as LaTeX**
- **no file — the user's details are in the prompt** → **generate from the starter
  template** (the only case that uses the template)

## Decide: first import vs re-import
- **No master yet → first import.**
- **A master already exists (recorded in memory, or an obvious `.tex` in the working
  directory) → re-import (a merge, not an overwrite).** The LaTeX master is the source
  of truth. A newly dropped file is treated as an incoming patch: diff its content
  against the master, propose the specific changes (added bullets, new role, updated
  dates), get confirmation, then apply them with `edit_latex_file`. **Never blindly
  overwrite the master** — that would wipe the user's LaTeX tweaks.

## First import — primary path (.tex)
1. The user's `.tex` IS the master — use it in place. Don't copy it into a scaffolded
   folder. If the user wants a different filename/location, move it once.
2. `validate_latex` on it. If it references missing packages or has errors, tell the
   user; offer to adapt it toward the starter template's package set.
3. If it compiles with `pdflatex` and the preamble has no scalable-font package
   (no `lmodern`/`fontspec`/explicit Type 1 font), offer to add
   `\usepackage[T1]{fontenc}` and `\usepackage{lmodern}` — these don't change content,
   they just keep the PDF crisp (a minimal TeX install renders default Computer Modern
   as fuzzy Type 3 bitmap fonts). Don't touch a file already using `fontspec`
   (xelatex/lualatex) or a custom font.
4. Record the master's path to persistent memory. Suggest **resume-build** for a PDF.

## First import — building the `.tex` (no `.tex` source)
The goal is a `.tex` that faithfully reproduces whatever the user gave you. The starter
template is reserved for one case only — generating from details typed into the prompt,
where there is no source document to reproduce.

### PDF — match it exactly
A PDF already *has* a finished design. Reproduce it; do not restyle it.
1. Read the PDF and inventory its layout before writing any LaTeX: section order and
   headings, one-column vs. two-column, the header/contact block, the **font, size,
   weight, and color** of each styled element (see the typography iron rule above),
   bullet vs. paragraph style, spacing/rules, and **the page count and where each page
   breaks**.
2. Capture **all content verbatim** — every role, date range, bullet, number, skill,
   and the exact wording. Keep the source's ordering. Do not summarize or trim to fit.
3. Build the `.tex` to mirror that layout: same section order and headings, same
   column structure, same header, comparable fonts/spacing. Choose packages that match
   the look (e.g. two-column, font choice) rather than forcing the starter template's.
   Always include `\usepackage[T1]{fontenc}` and a scalable-font package (`lmodern`, or
   whatever matches the chosen typeface) so the PDF stays crisp — a minimal TeX install
   emits fuzzy Type 3 bitmap fonts otherwise.
4. **The result must land on the same number of pages, with content breaking across
   pages the same way.** If your first build runs long or short, adjust margins/spacing
   to match — do not cut or pad content to hit the count.
5. `validate_latex`, then `compile_latex`, then **compare the built PDF against the
   original** — page count, layout, and content. Iterate until it matches. Record the
   master's path to persistent memory.

### Markdown — reproduce its structure
A `.md` resume is a given resume: reproduce it, don't reskin it with the template.
1. Read the `.md`. Its headings, ordering, bullets, dates, and wording are authoritative.
2. Write a clean LaTeX document that mirrors that structure — the same sections in the
   same order, the same bullets, the same wording, **verbatim, nothing added or
   dropped**. Use a minimal, readable preamble — always including
   `\usepackage[T1]{fontenc}` and `\usepackage{lmodern}` so the PDF uses scalable
   outline fonts (without them a minimal TeX install can emit fuzzy Type 3 bitmap
   fonts); do **not** pull in the starter template's design or macros.
3. Write the result as a `.tex` in the working directory (default `resume.tex`),
   `validate_latex`, then record its path to persistent memory.

### From the prompt — the template case
The user has no resume file and instead gives their details in the prompt, so there is
nothing to reproduce.
1. Start from `${CLAUDE_PLUGIN_ROOT}/templates/resume.tex`.
2. Fill its macros (`\entry`, `points`, sections) with the details the user provided —
   don't invent experience they didn't give you.
3. Write the result as a `.tex` in the working directory (default `resume.tex`),
   `validate_latex`, then record its path to persistent memory. This is the only path
   that uses the template.

## After import — snapshot to build/
Every import drops a timestamped copy of the resulting master into a `build/` folder
next to it (create `build/` if it isn't there):

    build/<master-stem>-<YYYYMMDD-HHMMSS>.tex

Use a real timestamp (e.g. `date +%Y%m%d-%H%M%S` via Bash) — not a placeholder. These
snapshots are an immutable version trail: the first import's snapshot preserves the
original, and **each later re-import/merge adds another**, so a future session can read
`build/` and see what the resume held before versus what's in it now. Never overwrite or
prune existing snapshots. The master in the working directory stays the live file
everyone edits and builds from. Tell the user where the snapshot landed.

## Output
- A valid `.tex` master exists in the working directory and is recorded in memory.
- A timestamped snapshot of it sits in `build/`.
- For a PDF source: the built PDF matches the original's layout, content, and page
  count — say so, and call out any place LaTeX forced a compromise.
- For any source: summarize what you imported and flag anything you couldn't reproduce
  faithfully (e.g. unreadable text, a font with no LaTeX equivalent).

## Optional: flag (don't fix) best-practice issues
After a faithful import, you may *gently flag* clear best-practice violations you noticed
in the source against the Do's & Don'ts in
`${CLAUDE_PLUGIN_ROOT}/references/resume-principles.md` — e.g. an Objective statement, a
"References available upon request" line, un-quantified bullets, or "Responsible for"
phrasing. **Only flag; never edit.** The iron rule still holds: import reproduces the
source verbatim. Point the user at **resume-tailor** / **resume-summarize** to act on
anything they want to change.
