# Resume Buddy

An AI-powered LaTeX resume workshop, packaged as a **Claude Code plugin**. Resume
Buddy bundles a local [MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server)
so the AI can create, edit, validate, and compile your resume as a real `.tex`
file — plus skills that drive the whole workflow.

The workflow is conversational: bring your resume (or start from a template), then
tell the AI what you want ("add my new job at Acme", "tighten the summary", "tailor
this for a senior backend role"), and it edits the LaTeX and produces an updated PDF.

---

## Prerequisites

| Tool | Purpose | Install |
|---|---|---|
| [Claude Code](https://code.claude.com/) | AI front-end + plugin host | See link |
| [uv](https://docs.astral.sh/uv/) | Runs the Python MCP server | `irm https://astral.sh/uv/install.ps1 \| iex` (Windows) · `curl -LsSf https://astral.sh/uv/install.sh \| sh` (macOS/Linux) |
| A LaTeX engine | Compiles `.tex` → PDF | TinyTeX recommended (below) |

**LaTeX engine.** The bundled server calls `pdflatex` to make PDFs, so you need a
LaTeX distribution on your `PATH`. We recommend **[TinyTeX](https://yihui.org/tinytex/)**:
lightweight (~150 MB), cross-platform, installs **without admin rights**, and fetches
extra packages on demand.

- **macOS / Linux** — `curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh`
- **Windows** (PowerShell, no admin) — `Invoke-WebRequest https://yihui.org/tinytex/install-bin-windows.bat -OutFile install-tinytex.bat; ./install-tinytex.bat`

Restart your shell and verify with `pdflatex --version`. If a compile reports a
missing package, install it with `tlmgr install <package>`. Already have **MiKTeX**,
**MacTeX**, or **TeX Live**? Any distribution with `pdflatex` on your `PATH` works.

---

## Install

Resume Buddy is its own plugin marketplace. From inside Claude Code:

```
/plugin marketplace add SiamRahman29/resume-buddy
/plugin install resume-buddy@resume-buddy
```

That registers the `latex-server` MCP and the resume skills globally. Then work in
any directory you like:

```
mkdir my-resume && cd my-resume
claude
```

In the session, run `/resume-init` to scaffold a starter, or drop an existing
resume in the folder and run `/resume-import`.

### Local development

To hack on the plugin from a clone:

```
git clone https://github.com/SiamRahman29/resume-buddy
/plugin marketplace add ./resume-buddy
/plugin install resume-buddy@resume-buddy
```

As long as `uv` is on your `PATH` (see Prerequisites), nothing else is needed — the
`latex-server` MCP launches via `uv run`, which installs the server's Python deps
automatically on first launch.

---

## How it works

- **The master is a `.tex` file you keep in your working directory** — the single
  source of truth the AI edits. Resume Buddy resolves it per session and remembers
  which file it is; there's no fixed path or `data/` folder to set up.
- **Bring your own `.tex`** and that file *is* the master — edited in place.
- **No LaTeX yet?** Bring a `.md` or `.pdf` and the AI fills the committed
  `templates/resume.tex` starter with your real content.
- **Compiled PDFs land in a `build/` folder** next to the master (disposable).

### Skills

| Skill | What it does |
|---|---|
| `/resume-init` | Seed a starter master for a new user with no resume yet |
| `/resume-import` | Bring in an existing resume (`.tex` directly, or fill the template from `.md`/`.pdf`); re-imports merge into the master |
| `/resume-build` | Compile the master to a PDF in `build/` |
| `/resume-tailor` | Tailor the resume (or a variant) to a pasted job description |
| `/resume-summarize` | Rewrite the top-of-resume summary for a target role |
| `/resume-analyze` | Three read-only passes vs. a JD: ATS keyword screen, 7-second hiring-manager scan, and a coach's apply/no-go read |
| `/cover-letter-write` | Draft a three-paragraph cover letter grounded in the resume and a JD |

---

## Usage examples

Talk to it naturally — or call the skills directly:

```
/resume-init
```
```
I dropped my resume in this folder — import it.
```
```
Add a position: Senior Engineer at Acme Corp, Jan 2024–present. Focus on distributed systems.
```
```
/resume-tailor   (then paste the job description)
```
```
/resume-build
```

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Skills/MCP not available | Confirm the plugin is installed: `/plugin` |
| MCP server won't start | Ensure `uv` is installed and on `PATH` |
| Compile fails with LaTeX errors | Ask the AI to `validate_latex` first; it shows the error |
| `pdflatex` not found | Install MiKTeX / MacTeX / TeX Live and ensure it's on `PATH` |
| Server rejected earlier | `claude mcp reset-project-choices` |
