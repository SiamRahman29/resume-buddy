# Resume Buddy

An AI-powered LaTeX resume workshop, packaged as a **Claude Code plugin**. Resume
Buddy bundles a local [MCP LaTeX Server](https://github.com/RobertoDure/mcp-latex-server)
so the AI can create, edit, validate, and compile your resume as a real `.tex`
file — plus skills that drive the whole workflow.

The workflow is conversational: bring your resume (or start from a template), then
tell the AI what you want ("add my new job at Acme", "tighten the summary", "tailor
this for a senior backend role"), and it edits the LaTeX and produces an updated PDF.

---

## Claude Code

**macOS/Linux/WSL**
```
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows (Powershell)**
```
irm https://claude.ai/install.ps1 | iex
```

**Windows (CMD)**
```
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```
## uv
Runs the Python server with the LaTeX MCP

**macOS/Linux/WSL**
```
curl -LsSf https://astral.sh/uv/install.sh \| sh
```

**Windows (Powershell)**
```
irm https://astral.sh/uv/install.ps1 \| iex
```

## LaTeX Engine
**macOS/Linux/WSL**
```
curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh
```
**Windows (Powershell)**
```
Invoke-WebRequest https://yihui.org/tinytex/install-bin-windows.bat -OutFile install-tinytex.bat; ./install-tinytex.bat
```

To verify after installation, run
```
pdflatex --version
```
If a compile reports a
missing package, install it with `tlmgr install <package>`. 

**Why do you need a LaTeX engine?** 

The bundled server calls `pdflatex` to make PDFs, so you need a
LaTeX distribution on your `PATH`. We recommend **[TinyTeX](https://yihui.org/tinytex/)**:
lightweight (~150 MB), cross-platform, installs **without admin rights**, and fetches
extra packages on demand.

Already have **MiKTeX**, **MacTeX**, or **TeX Live**? Any distribution with `pdflatex` on your `PATH` works.

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

---

## Releasing

> For maintainers. Users get updates by running `/plugin marketplace update`.

Installed plugins are **pinned to the `version` string** in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json). A user's `/plugin
marketplace update` only pulls new code when that string changes — so **bumping the
version is the release.** Commits that don't bump it (docs, WIP, refactors) never reach
users, even after a refresh.

Because the marketplace `source` is `./` (this repo's default branch), a release ships
whatever is at `main` HEAD when you bump the version. So: **keep `main` shippable, and
only bump the version when it is.**

To cut a release:

1. Pick the new version per [SemVer](https://semver.org/) (`MAJOR.MINOR.PATCH`).
2. Move `## [Unreleased]` notes into a new dated section in
   [`CHANGELOG.md`](CHANGELOG.md), and update the compare links at the bottom.
3. Bump `"version"` in `.claude-plugin/plugin.json`.
4. Commit (e.g. `release: v0.2.0`) and push to `main`.

That's it — pushing a changed `version` to `main` triggers the
[release workflow](.github/workflows/release.yml), which tags `v0.2.0` and cuts a
GitHub Release using the matching `CHANGELOG.md` section as the notes. Commits that
don't change `version` are ignored, and re-running with an already-released version is
a safe no-op.

For the release notes to look right, **bump the `version` and update the CHANGELOG in
the same push** — the workflow reads the `## [X.Y.Z]` section that matches the new
version.

Never remove the `version` field — without it, *every* commit to `main` becomes an
automatic update for users.

---

## How it works

- **The master is a `.tex` file you keep in your working directory** — the single
  source of truth the AI edits. Resume Buddy resolves it per session and remembers
  which file it is; there's no fixed path or `data/` folder to set up.
- **Bring your own `.tex`** and that file *is* the master — edited in place.
- **No LaTeX yet?** Bring a `.md` or `.pdf` and the AI fills the committed
  `templates/resume.tex` starter with your real content.
- **Compiled PDFs land in a `build/` folder** next to the master (disposable).