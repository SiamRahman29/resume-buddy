# Resume Buddy

An AI-powered LaTeX resume workshop, packaged as a **Claude Code plugin**. Resume
Buddy bundles a local [MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server)
so the AI can create, edit, validate, and compile your resume as a real `.tex`
file — plus skills that drive the whole workflow.

The workflow is conversational: bring your resume (or start from a template), then
tell the AI what you want ("add my new job at Acme", "tighten the summary", "tailor
this for a senior backend role"), and it edits the LaTeX and produces an updated PDF.

This plugin incorporates prompts and techniques from [@jerryjhlee](https://www.instagram.com/jerryjhlee). Check out his account for more career advice!

---

## Prerequisites

| Requirement | What it's for |
|---|---|
| Claude Code | The harness we'll use |
| uv | Runs the Python MCP Server |
| TinyTeX | A LaTeX engine for build operations |

Already have **MiKTeX**, **MacTeX**, or **TeX Live**? Any distribution with `pdflatex` on your `PATH` works.

---

## Install

You need to install uv and a LaTeX engine. Run the following commands in your *terminal*

#### macOS/Linux/WSL
```
curl -LsSf https://astral.sh/uv/install.sh \| sh
```
Then:
```
curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh
```
Then start a claude code session. From inside claude code, run:
```
/plugin marketplace add SiamRahman29/resume-buddy
/plugin install resume-buddy@resume-buddy
```

If you choose to install the plugin repo-only, you will only be able to use the plugin in the current folder.

---

#### Windows (Powershell)
```
irm https://astral.sh/uv/install.ps1 \| iex
```
then:
```
Invoke-WebRequest https://yihui.org/tinytex/install-bin-windows.bat -OutFile install-tinytex.bat; ./install-tinytex.bat
```
Then start a claude code session. From inside claude code, run:
```
/plugin marketplace add SiamRahman29/resume-buddy
/plugin install resume-buddy@resume-buddy
```
If you choose to install the plugin repo-only, you will only be able to use the plugin in the current folder.

---

### Getting Started

In a session, drop an existing resume in the folder where claude code is running and starting talking naturally. 

Don't have a resume? Give claude information about yourself and ask it to create on for you.

For local development, troubleshooting, and releasing, see [DEVELOPMENT.md](DEVELOPMENT.md).

---

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

## How it works

- **The master is a `.tex` file you keep in your working directory** — the single
  source of truth the AI edits. Resume Buddy resolves it per session and remembers
  which file it is; there's no fixed path or `data/` folder to set up.
- **Bring your own `.tex`** and that file *is* the master — edited in place.
- **No LaTeX yet?** Bring a `.md` or `.pdf` and the AI fills the committed
  `templates/resume.tex` starter with your real content.
- **Compiled PDFs land in a `build/` folder** next to the master (disposable).